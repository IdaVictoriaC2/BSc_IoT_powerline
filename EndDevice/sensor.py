import time
import sqlite3
import os

BUFFER_DB = "/home/pi3/buffer.db"
MAX_BUFFER_LINES = 3000

# AT DEPLOYMENT REPLACE THIS FUNCTION WITH ACTUAL SENSOR READING
def get_telemetry_data():
    """ Read the physical CPU-temperature of the Raspberry Pi's chip"""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            # Value is in milli-degress (fx 45000 = 45.0 degress)
            return float(f.read().strip()) / 1000.0
    except:
        return 40.0 # Standard fallback

# AT DEPLOYMENT REPLACE THIS FUNCTION WITH ACTUAL SENSOR READINGS
# KEEP TIME, HEX-ENCODING AND 12-BYTE PAYLOAD STRUCTURE INTACT
def get_hex_data():
    """Generates 12-byte payload: 4-byte timestamp + 8-byte sensor payload."""
    timestamp = int(time.time())
    ts_hex = f"{timestamp:08X}"
    
    cpu_temp = get_telemetry_data()
    amb = cpu_temp - 25.00
    imm = amb + 3.00
    con = imm + 20.00
    t_amb, t_imm, t_con, t_cpu = int(amb*100), int(imm*100), int(con*100), int(cpu_temp*100)
    sensor_hex = f"{(t_amb & 0xFFFF):04X}{(t_imm & 0xFFFF):04X}{(t_con & 0xFFFF):04X}{(t_cpu & 0xFFFF):04X}"
    return ts_hex + sensor_hex, timestamp

def init_db():
    """Initialize the SQLite database with the readings table."""
    directory = os.path.dirname(BUFFER_DB)
    if directory:
        os.makedirs(directory, exist_ok=True)
    
    conn = sqlite3.connect(BUFFER_DB)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS readings (
            timestamp INTEGER PRIMARY KEY,
            payload TEXT NOT NULL
        )
    """)
    cursor.execute("PRAGMA journal_mode=WAL")
    conn.commit()
    conn.close()

def save_to_buffer(payload, timestamp):
    """Saves data locally in case LoRa-module fails or network fails."""
    try:
        conn = sqlite3.connect(BUFFER_DB)
        cursor = conn.cursor()
        
        max_retries = 3
        for attempt in range(max_retries):
            try:
                cursor.execute("""
                    INSERT INTO readings (timestamp, payload)
                    VALUES (?, ?)
                """, (timestamp, payload))
                break
            except sqlite3.OperationalError as e:
                if "locked" in str(e) and attempt < max_retries - 1:
                    time.sleep(0.1)
                else:
                    raise

        # Check if we exceed max lines and delete oldest if needed
        cursor.execute("SELECT COUNT(*) FROM readings")
        row_count = cursor.fetchone()[0]
        
        if row_count > MAX_BUFFER_LINES:
            cursor.execute("""
                DELETE FROM readings WHERE timestamp NOT IN (
                    SELECT timestamp FROM readings ORDER BY timestamp DESC LIMIT ?
                )
            """, (MAX_BUFFER_LINES,))
        
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Failed to write to buffer: {e}")

def main():
    init_db()
    while True:
        payload, timestamp = get_hex_data()
        save_to_buffer(payload, timestamp)
        time.sleep(30)

if __name__ == "__main__":
    main()