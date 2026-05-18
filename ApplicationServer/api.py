from fastapi import FastAPI, HTTPException, Depends, Header, Request, Query
from fastapi.responses import RedirectResponse
from psycopg2.extras import RealDictCursor
from typing import Optional
from datetime import datetime
import psycopg2
import os
import re
import uvicorn

# --- Configuration ---
DB_CONFIG = {
    "host": os.environ["DB_HOST"],
    "port": os.environ["DB_PORT"],
    "dbname": os.environ["DB_NAME"],
    "user": os.environ["DB_USER"],
    "password": os.environ["DB_PASS"],
}

app = FastAPI(title="Power Line Monitoring SCADA API", version="1.4.0",
             description="""
             REST API for the Power Line Monitoring System.
             The API exposes telemetry data as JSON for dashboard, SCADA-related
             integration and administrative monitoring. Authorization is based on
             Authentik group membership.

             Roles:
             - admin: full access
             - as_admin: Application Server administrator access
             - viewer: read-only telemetry access
             - ns_admin: Network Server administrator, no Application Server API access by default
                 """,
                 docs_url="/docs",
                 redoc_url="/redoc",
                 openapi_url="/openapi.json",
             )

# --- Helper: Database & Audit Logging ---
def get_db_connection():
    try:
        return psycopg2.connect(**DB_CONFIG)
    except Exception as e:
        print(f"Database connection failed: {e}")
        return None


def log_to_audit(action: str, username: str, role: str, details: str):
    """
    Logs API access and authorization events to the shared audit_log table.
    The audit_log table already supports event_type, performed_by and details.
    """
    conn = get_db_connection()
    if not conn:
        return

    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO audit_log (event_type, performed_by, details, description)
            VALUES (%s, %s, %s, %s);
        """
        formatted_details = f"Role: {role} | {details}"
        cursor.execute(query, (action, username, formatted_details, details))
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Failed to write audit log: {e}")
        conn.rollback()
        conn.close()


def parse_authentik_groups(groups_header: Optional[str]) -> list[str]:
    """
    Authentik forwards groups as a single header.
    In this setup, groups are separated by '|', for example:
    'authentik Admins|Grafana Access|NS Access|AS Access'.

    Comma and semicolon are also accepted as fallback separators.
    """
    if not groups_header:
        return []

    return [
        group.strip()
        for group in re.split(r"[|,;]", groups_header)
        if group.strip()
    ]


def map_groups_to_role(groups: list[str]) -> str:
    """
    Maps Authentik groups to API roles.
    Matching is case-insensitive.
    Priority:
    authentik admins > AS access > Grafana access > NS access
    """

    normalized_groups = {group.strip().lower() for group in groups}

    if "authentik admins" in normalized_groups:
        return "admin"

    if "as access" in normalized_groups:
        return "as_admin"

    if "grafana access" in normalized_groups:
        return "viewer"

    if "ns access" in normalized_groups:
        return "ns_admin"

    return "unauthorized"


# --- Dependency: Authentik identity from forward-auth headers ---
async def get_current_user(
    request: Request,
    x_authentik_username: Optional[str] = Header(default=None, alias="X-authentik-username"),
    x_authentik_groups: Optional[str] = Header(default=None, alias="X-authentik-groups"),
    x_authentik_email: Optional[str] = Header(default=None, alias="X-authentik-email"),
    x_authentik_name: Optional[str] = Header(default=None, alias="X-authentik-name"),
    x_authentik_uid: Optional[str] = Header(default=None, alias="X-authentik-uid"),
):
    """
    The API trusts these headers only because Traefik/AuthentiK is placed in front
    of the service. The API container must not be directly reachable from outside
    the Docker/proxy network, otherwise these headers could be spoofed.
    """

    if not x_authentik_username:
        log_to_audit(
            "MISSING_AUTHENTIK_HEADERS",
            "UNKNOWN",
            "unauthenticated",
            f"Request rejected. Path: {request.url.path}"
        )
        raise HTTPException(
            status_code=401,
            detail="Missing Authentik authentication headers"
        )

    groups = parse_authentik_groups(x_authentik_groups)
    role = map_groups_to_role(groups)

    user = {
        "username": x_authentik_username,
        "name": x_authentik_name or x_authentik_username,
        "email": x_authentik_email,
        "uid": x_authentik_uid,
        "groups": groups,
        "role": role,
    }

    if role == "unauthorized":
        log_to_audit(
            "UNAUTHORIZED_GROUP",
            user["username"],
            role,
            f"User has no API-authorized Authentik group. Groups: {groups}"
        )
        raise HTTPException(
            status_code=403,
            detail="User does not belong to an API-authorized group"
        )

    return user


def require_role(allowed_roles: list[str]):
    async def role_verifier(user: dict = Depends(get_current_user)):
        if user["role"] not in allowed_roles:
            log_to_audit(
                "UNAUTHORIZED_ACCESS",
                user["username"],
                user["role"],
                f"Tried to access endpoint requiring one of: {allowed_roles}"
            )
            raise HTTPException(
                status_code=403,
                detail="Insufficient permissions"
            )
        return user

    return role_verifier


# --- API Endpoints ---
@app.get("/", include_in_schema=False)
def root():
    """
    Redirect users to Swagger UI after Authentik login.
    """
    return RedirectResponse(url="/docs")

@app.get(
    "/api/me",
    tags=["Authentication"],
    summary="Show current authenticated user",
)
def get_me(user: dict = Depends(get_current_user)):
    return user

@app.get(
    "/api/health",
    tags=["System"],
    summary="Check API and database health",
)
def health_check(user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor()
    cursor.execute("SELECT 1;")
    cursor.fetchone()
    cursor.close()
    conn.close()

    return {
        "status": "ok",
        "api": "running",
        "database": "available",
    }

@app.get(
    "/api/status/latest",
    tags=["Telemetry"],
    summary="Get latest telemetry measurement",
    description="Returns the newest telemetry record stored in the database. Can optionally be filtered by device EUI",
)
def get_latest(
    device_eui: Optional[str] = Query(default=None, description="Optional DevEUI filter"),
    user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))
):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    if device_eui:
        cursor.execute("""
            SELECT *
            FROM sensor_data
            WHERE device_eui = %s
            ORDER BY device_timestamp DESC
            LIMIT 1;
        """, (device_eui,))
    else:
        cursor.execute("""
            SELECT *
            FROM sensor_data
            ORDER BY device_timestamp DESC
            LIMIT 1;
        """)
    result = cursor.fetchone()
    cursor.close()
    conn.close()

    log_to_audit(
        "GET_LATEST",
        user["username"],
        user["role"],
        f"Retrieved latest telemetry measurement. Device: {device_eui or 'all'}"
    )

    return result or {"message": "No telemetry data available"}


@app.get(
    "/api/status/history",
    tags=["Telemetry"],
    summary="Get telemetry history",
    description="""
Returns telemetry records as JSON. Results can be filtered by device EUI and
time interval, and sorted by timestamp or device EUI. This endpoint is intended
for dashboard and SCADA-related integration.
    """,
)
def get_history(
    device_eui: Optional[str] = Query(default=None, description="Optional DevEUI filter"),
    start_time: Optional[str] = Query(default=None, description="Start time, e.g. 2026-05-07T00:00:00Z"),
    end_time: Optional[str] = Query(default=None, description="End time, e.g. 2026-05-08T00:00:00Z"),
    limit: int = Query(default=100, ge=1, le=5000, description="Maximum number of records"),
    sort_by: str = Query(
        default="device_timestamp",
        description="Sort field: device_timestamp, device_eui, server_timestamp, conductor_temp, ambient_temp"
    ),
    sort_order: str = Query(
        default="desc",
        description="Sort order: asc or desc"
    ),
    user: dict = Depends(require_role(["admin", "as_admin", "viewer"])),
):
    allowed_sort_fields = {
        "device_timestamp": "device_timestamp",
        "server_timestamp": "server_timestamp",
        "device_eui": "device_eui",
        "ambient_temp": "ambient_temp",
        "immediate_temp": "immediate_temp",
        "conductor_temp": "conductor_temp",
        "cpu_temp": "cpu_temp",
    }

    allowed_sort_orders = {
        "asc": "ASC",
        "desc": "DESC",
    }

    if sort_by not in allowed_sort_fields:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid sort_by value. Allowed values: {list(allowed_sort_fields.keys())}"
        )

    if sort_order.lower() not in allowed_sort_orders:
        raise HTTPException(
            status_code=400,
            detail="Invalid sort_order value. Allowed values: asc, desc"
        )

    order_column = allowed_sort_fields[sort_by]
    order_direction = allowed_sort_orders[sort_order.lower()]

    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    where_clauses = []
    params = []

    if device_eui:
        where_clauses.append("device_eui = %s")
        params.append(device_eui)

    if start_time:
        where_clauses.append("device_timestamp >= %s")
        params.append(start_time)

    if end_time:
        where_clauses.append("device_timestamp <= %s")
        params.append(end_time)

    where_sql = ""
    if where_clauses:
        where_sql = "WHERE " + " AND ".join(where_clauses)

    params.append(limit)

    query = f"""
        SELECT *
        FROM sensor_data
        {where_sql}
        ORDER BY {order_column} {order_direction}, device_timestamp DESC
        LIMIT %s;
    """

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute(query, params)
    results = cursor.fetchall()
    cursor.close()
    conn.close()

    log_to_audit(
        "GET_HISTORY",
        user["username"],
        user["role"],
        (
            f"Retrieved telemetry history. Device: {device_eui}, "
            f"start: {start_time}, end: {end_time}, limit: {limit}, "
            f"sort_by: {sort_by}, sort_order: {sort_order}"
        ),
    )

    return {
        "count": len(results),
        "sort_by": sort_by,
        "sort_order": sort_order.lower(),
        "records": results,
    }

@app.get(
    "/api/devices",
    tags=["Telemetry"],
    summary="List known End Devices",
    description="Returns known End Devices based on telemetry records.",
)
def list_devices(user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT
            e.dev_eui,
            e.location,
            COUNT(s.id) AS measurement_count,
            MIN(s.device_timestamp) AS first_seen,
            MAX(s.device_timestamp) AS last_seen,
            CASE
                WHEN MAX(s.device_timestamp) > NOW() - INTERVAL '2 minutes' THEN 'online'
                WHEN MAX(s.device_timestamp) > NOW() - INTERVAL '10 minutes' THEN 'delayed'
                WHEN MAX(s.device_timestamp) IS NULL THEN 'no_data'
                ELSE 'offline'
            END AS status
        FROM end_devices e
        LEFT JOIN sensor_data s
            ON e.dev_eui = s.device_eui
        GROUP BY e.dev_eui, e.location
        ORDER BY last_seen DESC NULLS LAST;
    """)
    devices = cursor.fetchall()
    cursor.close()
    conn.close()

    return {
        "count": len(devices),
        "devices": devices,
    }

@app.get(
    "/api/lora/metadata",
    tags=["LoRaWAN"],
    summary="Get LoRaWAN radio metadata",
    description="Returns LoRaWAN metadata such as RSSI, SNR, spreading factor, frequency and frame counter.",
)
def get_lora_metadata(
    device_eui: Optional[str] = Query(default=None, description="Optional DevEUI filter"),
    limit: int = Query(default=100, ge=1, le=5000),
    user: dict = Depends(require_role(["admin", "as_admin", "viewer"])),
):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    where_clauses = []
    params = []

    if device_eui:
        where_clauses.append("device_eui = %s")
        params.append(device_eui)

    where_sql = ""
    if where_clauses:
        where_sql = "WHERE " + " AND ".join(where_clauses)

    params.append(limit)

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute(f"""
        SELECT
            received_at,
            device_eui,
            application_id,
            gateway_id,
            frequency_hz,
            bandwidth_hz,
            spreading_factor,
            rssi_dbm,
            snr_db,
            f_cnt
        FROM lora_uplink_metadata
        {where_sql}
        ORDER BY received_at DESC
        LIMIT %s;
    """, params)

    records = cursor.fetchall()
    cursor.close()
    conn.close()

    log_to_audit(
        "GET_LORA_METADATA",
        user["username"],
        user["role"],
        f"Retrieved LoRa metadata. Device: {device_eui or 'all'}, limit: {limit}",
    )

    return {
        "count": len(records),
        "records": records,
    }
    
@app.get(
    "/api/recovery/pending",
    tags=["Recovery"],
    summary="Get pending recovery intervals",
    description="Returns active recovery intervals for End Devices.",
)
def get_pending_recovery(
    user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))
):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT
            device_eui,
            app_id,
            to_timestamp(start_ts) AS start_time,
            to_timestamp(end_ts) AS end_time,
            end_ts - start_ts AS interval_seconds,
            retry_count,
            to_timestamp(last_requested_at) AS last_requested_at,
            created_at,
            updated_at
        FROM pending_recovery
        ORDER BY updated_at DESC;
    """)
    records = cursor.fetchall()
    cursor.close()
    conn.close()

    return {
        "count": len(records),
        "records": records,
    }
    
@app.get(
    "/api/admin/audit",
    tags=["Admin"],
    summary="View audit log",
    description="Returns recent audit log entries. Only admin and AS admin users can access this endpoint.",
)
def view_audit(
    limit: int = Query(default=50, ge=1, le=500),
    user: dict = Depends(require_role(["admin", "as_admin"])),
):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT *
        FROM audit_log
        ORDER BY created_at DESC
        LIMIT %s;
    """, (limit,))
    logs = cursor.fetchall()
    cursor.close()
    conn.close()

    log_to_audit(
        "VIEW_AUDIT",
        user["username"],
        user["role"],
        f"Viewed latest audit log entries. Limit: {limit}",
    )

    return {
        "count": len(logs),
        "records": logs,
    }


@app.post(
    "/api/admin/purge",
    tags=["Admin"],
    summary="Purge old telemetry data",
    description="Deletes telemetry records older than 30 days. Only admin and AS admin users can access this endpoint.",
)
def purge_data(user: dict = Depends(require_role(["admin", "as_admin"]))):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor()
    cursor.execute("""
        DELETE FROM sensor_data
        WHERE device_timestamp < NOW() - INTERVAL '30 days';
    """)
    count = cursor.rowcount
    conn.commit()
    cursor.close()
    conn.close()

    log_to_audit(
        "DATA_PURGE",
        user["username"],
        user["role"],
        f"Deleted {count} telemetry rows older than 30 days"
    )

    return {"status": "success", "deleted": count}


if __name__ == "__main__":
    print("Starting SCADA REST API on port 8005...")
    uvicorn.run("api:app", host="0.0.0.0", port=8005, reload=True)
