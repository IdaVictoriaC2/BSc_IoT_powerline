from fastapi import FastAPI, HTTPException, Depends, Header, Request
from psycopg2.extras import RealDictCursor
import psycopg2
import os
import re
import uvicorn
from typing import Optional

# --- Configuration ---
DB_CONFIG = {
    "host": os.environ["DB_HOST"],
    "port": os.environ["DB_PORT"],
    "dbname": os.environ["DB_NAME"],
    "user": os.environ["DB_USER"],
    "password": os.environ["DB_PASS"],
}

app = FastAPI(title="Power Line Monitoring SCADA API", version="1.3.0")

# --- Authentik group -> API role mapping ---
GROUP_ROLE_PRIORITY = [
    ("authentik Admins", "admin"),
    ("AS access", "as_admin"),
    ("Grafana access", "viewer"),
    ("NS Access", "ns_admin"),
]

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
    Authentik forwards groups as a header string.
    This parser accepts comma-separated group names and trims whitespace.
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

@app.get("/api/status/latest")
def get_latest(user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
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
        "Retrieved latest telemetry measurement"
    )

    return result or {"message": "No telemetry data available"}


@app.get("/api/status/history")
def get_history(
    limit: int = 10,
    user: dict = Depends(require_role(["admin", "as_admin", "viewer"]))
):
    if limit < 1 or limit > 1000:
        raise HTTPException(status_code=400, detail="Limit must be between 1 and 1000")

    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT *
        FROM sensor_data
        ORDER BY device_timestamp DESC
        LIMIT %s;
    """, (limit,))
    results = cursor.fetchall()
    cursor.close()
    conn.close()

    log_to_audit(
        "GET_HISTORY",
        user["username"],
        user["role"],
        f"Retrieved telemetry history. Limit: {limit}"
    )

    return results


@app.get("/api/admin/audit")
def view_audit(user: dict = Depends(require_role(["admin", "as_admin"]))):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=503, detail="Database unavailable")

    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("""
        SELECT *
        FROM audit_log
        ORDER BY created_at DESC
        LIMIT 50;
    """)
    logs = cursor.fetchall()
    cursor.close()
    conn.close()

    log_to_audit(
        "VIEW_AUDIT",
        user["username"],
        user["role"],
        "Viewed latest audit log entries"
    )

    return logs


@app.post("/api/admin/purge")
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
