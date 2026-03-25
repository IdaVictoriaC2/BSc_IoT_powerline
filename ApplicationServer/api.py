from fastapi import FastAPI, HTTPException, Security, Depends, Header, Request
from fastapi.security.api_key import APIKeyHeader
import psycopg2
from psycopg2.extras import RealDictCursor
import uvicorn
from starlette import status

# --- Configuration ---
DB_CONFIG = {
    "host": "localhost",
    "port": "5433",
    "dbname": "powerline_telemetry",
    "user": "app_user",
    "password": "IMbachelor26"
}
USERS = {
    "key_user_1": {"name": "Operator01", "role": "user"},
    "key_mgr_1":  {"name": "ShiftManager", "role": "manager"},
    "key_admin_1": {"name": "SystemAdmin", "role": "admin"}
}

API_KEY_NAME = "API-Key"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

app = FastAPI(title="Power Line SCADA API", version="1.2.0")

# --- Helper: Database & Audit Logging ---
def get_db_connection():
    try:
        return psycopg2.connect(**DB_CONFIG)
    except Exception:    
        return None

def log_to_audit(action: str, username: str, role: str, details: str):
    """NFR16: Logger ALTID hvem, hvad og hvornår."""
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        query = "INSERT INTO audit_log (event_type, performed_by, details) VALUES (%s, %s, %s);"
        cursor.execute(query, (action, username, f"Role: {role} | {details}"))
        conn.commit()
        cursor.close()
        conn.close()
      
# --- Dependency for Security ---
async def get_current_user(api_key: str = Depends(api_key_header)):
    if api_key in USERS:
        return USERS[api_key]
    raise HTTPException(status_code=401, detail="Invalid API Key")

def check_role(required_roles: list):
    """Tjekker om brugerens rolle er på den tilladte liste."""
    async def role_verifier(current_user: dict = Depends(get_current_user)):
        if current_user["role"] not in required_roles:
            log_to_audit("UNAUTHORIZED_ACCESS", current_user["name"], current_user["role"], "Tried to access restricted endpoint")
            raise HTTPException(status_code=403, detail="Insufficient permissions")
        return current_user
    return role_verifier

# --- API Endpoints ---

@app.get("/api/status/latest")
def get_latest(user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM sensor_data ORDER BY received_at DESC LIMIT 1;")
    result = cursor.fetchone()
    conn.close()
    log_to_audit("GET_LATEST", user["name"], user["role"], "Hentede seneste måling")
    return result or {"message": "Ingen data"}

@app.get("/api/status/history")
def get_history(user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM sensor_data ORDER BY received_at DESC LIMIT 10;")
    results = cursor.fetchall()
    conn.close()
    log_to_audit("GET_HISTORY", user["name"], user["role"], "Hentede historik")
    return results

@app.get("/api/admin/audit")
def view_audit(user: dict = Depends(require_role(["admin"]))):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute("SELECT * FROM audit_log ORDER BY created_at DESC LIMIT 50;")
    logs = cursor.fetchall()
    conn.close()
    return logs

@app.post("/api/admin/purge")
def purge_data(user: dict = Depends(require_role(["admin"]))):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM sensor_data WHERE received_at < NOW() - INTERVAL '30 days';")
    count = cursor.rowcount
    conn.commit()
    conn.close()
    log_to_audit("DATA_PURGE", user["name"], user["role"], f"Slettede {count} gamle rækker")
    return {"status": "success", "deleted": count}

if __name__ = "__main__":
    print("Starting SCADA REST API on port 8005...")
    uvicorn.run("api:app", host="0.0.0.0", port=8005, reload=True)
