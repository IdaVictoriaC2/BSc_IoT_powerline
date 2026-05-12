import paho.mqtt.client as mqtt
import psycopg2
import json
import base64
import struct
import datetime
import time
import os
import threading
from zoneinfo import ZoneInfo

# MQTT Broker (ChirpStack Mosquitto)
MQTT_BROKER = os.environ["MQTT_BROKER"]
MQTT_PORT = int(os.environ.get("MQTT_PORT", "8883"))
MQTT_TOPIC = os.environ.get("MQTT_TOPIC", "application/+/device/+/event/up")

# PostgreSQL SCADA Database
DB_HOST = os.environ["DB_HOST"]
DB_PORT = os.environ["DB_PORT"]
DB_NAME = os.environ["DB_NAME"]
DB_USER = os.environ["DB_USER"]
DB_PASS = os.environ["DB_PASS"]

CA_CERT_PATH = os.environ["MQTT_CA_CERT_PATH"]
last_cleanup_date = None

TEMP_LIMIT_MAX = float(os.environ.get("TEMP_LIMIT_MAX", "150"))
TEMP_LIMIT_MIN = float(os.environ.get("TEMP_LIMIT_MIN", "-40"))
MAX_TEMP_JUMP_PER_MINUTE = float(os.environ.get("MAX_TEMP_JUMP_PER_MINUTE", "5.0"))

MIN_VALID_TIME = int(os.environ.get("MIN_VALID_TIME", "1767225600"))  # 2026-01-01 00:00:00 UTC
MAX_FUTURE_BUFFER = int(os.environ.get("MAX_FUTURE_BUFFER", "60")) # 60 seconds

MAX_RECOVERY_WINDOW_SECONDS = int(os.environ.get("MAX_RECOVERY_WINDOW_SECONDS", "86400")) # 24 hours
MAX_GAP = int(os.environ.get("MAX_GAP", "75"))

RECOVERY_RETRY_AFTER_SECONDS = int(os.environ.get("RECOVERY_RETRY_AFTER_SECONDS", "3600")) # 1 hour
MAX_RECOVERY_RETRIES = int(os.environ.get("MAX_RECOVERY_RETRIES", "3"))
PENDING_GAP_CHECK_INTERVAL = int(os.environ.get("PENDING_GAP_CHECK_INTERVAL", "60"))
GAP_FILL_TOLERANCE_SECONDS = int(os.environ.get("GAP_FILL_TOLERANCE_SECONDS", "45"))

pending_gaps_lock = threading.Lock()

# --- Database Connection ---
def get_db_connection():
    """Establishes a connection to the PostgreSQL database."""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        return conn
    except Exception as e:
        print(f"Database connection failed: {e}")
        return None

def log_event(event_type, details, performed_by="mqtt-listener", role="system"):
    """
    Logs system events in the same audit_log structure used by api.py.
    mqtt-listener.py logs as a system component rather than an authenticated user.
    """
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            query = """
                INSERT INTO audit_log (event_type, performed_by, details, description)
                VALUES (%s, %s, %s, %s);
            """
            formatted_details = f"Role: {role} | {details}"
            cursor.execute(query, (event_type, performed_by, formatted_details, details))
            conn.commit()
            cursor.close()
            conn.close()
        except Exception as e:
            print(f"Failed to write audit log: {e}")
            conn.rollback()
            conn.close()

def get_pending_gap(dev_eui):
    conn = get_db_connection()
    if not conn:
        return None

    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count
            FROM pending_recovery
            WHERE device_eui = %s;
        """, (dev_eui,))
        row = cursor.fetchone()
        cursor.close()
        conn.close()

        if not row:
            return None

        return {
            "device_eui": row[0],
            "app_id": row[1],
            "start_ts": row[2],
            "end_ts": row[3],
            "last_requested_at": row[4],
            "retry_count": row[5],
        }

    except Exception as e:
        print(f"Failed to get pending recovery gap for {dev_eui}: {e}")
        conn.close()
        return None


def upsert_pending_gap(dev_eui, app_id, start_ts, end_ts, last_requested_at, retry_count):
    conn = get_db_connection()
    if not conn:
        return False

    try:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO pending_recovery
                (device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count, updated_at)
            VALUES
                (%s, %s, %s, %s, %s, %s, NOW())
            ON CONFLICT (device_eui)
            DO UPDATE SET
                app_id = EXCLUDED.app_id,
                start_ts = EXCLUDED.start_ts,
                end_ts = EXCLUDED.end_ts,
                last_requested_at = EXCLUDED.last_requested_at,
                retry_count = EXCLUDED.retry_count,
                updated_at = NOW();
        """, (dev_eui, app_id, start_ts, end_ts, last_requested_at, retry_count))

        conn.commit()
        cursor.close()
        conn.close()
        return True

    except Exception as e:
        print(f"Failed to upsert pending recovery gap for {dev_eui}: {e}")
        conn.rollback()
        conn.close()
        return False


def delete_pending_gap(dev_eui):
    conn = get_db_connection()
    if not conn:
        return False

    try:
        cursor = conn.cursor()
        cursor.execute("""
            DELETE FROM pending_recovery
            WHERE device_eui = %s;
        """, (dev_eui,))
        conn.commit()
        cursor.close()
        conn.close()
        return True

    except Exception as e:
        print(f"Failed to delete pending recovery gap for {dev_eui}: {e}")
        conn.rollback()
        conn.close()
        return False


def list_pending_gaps():
    conn = get_db_connection()
    if not conn:
        return []

    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count
            FROM pending_recovery
            ORDER BY updated_at ASC;
        """)
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        return [
            {
                "device_eui": row[0],
                "app_id": row[1],
                "start_ts": row[2],
                "end_ts": row[3],
                "last_requested_at": row[4],
                "retry_count": row[5],
            }
            for row in rows
        ]

    except Exception as e:
        print(f"Failed to list pending recovery gaps: {e}")
        conn.close()
        return []

# --- MQTT Callbacks ---
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected to MQTT with reason code {reason_code}, listening at {MQTT_TOPIC}", flush=True)
    client.subscribe(MQTT_TOPIC, qos=1)

def on_disconnect(client, userdata, disconnect_flags, reason_code, properties):
    print(f"Disconnected from MQTT. Reason: {reason_code}", flush=True)

# --- Payload Decoding Logic ---
def decode_payload(base64_data):
    try:
        raw_bytes = base64.b64decode(base64_data)
        measurements = []
        if len(raw_bytes) % 12 != 0:
            print(f"Warning: Received malformed payload of {len(raw_bytes)} bytes. Skipping.")
            return [], raw_bytes.hex()

        for i in range(0, len(raw_bytes), 12):
            block = raw_bytes[i:i+12]

            if len(block) == 12 and block != b'\x00' * 12:
                vals = struct.unpack('>Lhhhh', block)
                dt = datetime.datetime.fromtimestamp(vals[0], datetime.timezone.utc)
                measurements.append((dt, round(vals[1]/100.0, 2), round(vals[2]/100.0, 2), round(vals[3]/100.0, 2), round(vals[4]/100.0, 2), block.hex()))
        measurements.sort(key=lambda x: x[0]) #sort by time from buffer (oldest first)
        return measurements, raw_bytes.hex()
    except Exception as e:
        print(f"Error decoding: {e}")
        return [], ""

def auto_purge_old_data():
    """Automated Retention Policy (NFR15). Purges data older than 30 days."""
    global last_cleanup_date
    current_date = datetime.date.today()

    # Kør kun oprydning hvis det er en ny dag
    if last_cleanup_date != current_date:
        print(f"Running automated retention policy (Purging data older than 30 days)...")
        conn = get_db_connection()
        if conn:
            try:
                cursor = conn.cursor()
                # SQL: Slet alt der er ældre end 30 dage
                query = "DELETE FROM sensor_data WHERE device_timestamp < NOW() - INTERVAL '30 days';"                
                cursor.execute(query)
                deleted_rows = cursor.rowcount
                conn.commit()

                # Log hændelsen i jeres nye Audit Log (NFR16)
                log_event("SYSTEM_PURGE", f"Automated cleanup deleted {deleted_rows} records.")

                cursor.close()
                conn.close()
                last_cleanup_date = current_date
                print(f"Cleanup complete. Deleted {deleted_rows} rows.")
            except Exception as e:
                print(f"Error during auto-purge: {e}")

def check_for_missing_data(client, dev_eui, app_id, current_device_ts):
    conn = get_db_connection()
    if not conn:
        return

    cursor = conn.cursor()
    last_record = get_last_measurement(cursor, dev_eui)
    cursor.close()
    conn.close()

    if not last_record:
        return

    last_ts = last_record[0]

    if last_ts.tzinfo is None:
        last_ts = last_ts.replace(tzinfo=datetime.timezone.utc)

    if current_device_ts.tzinfo is None:
        current_device_ts = current_device_ts.replace(tzinfo=datetime.timezone.utc)

    gap = current_device_ts.timestamp() - last_ts.timestamp()

    if gap <= MAX_GAP:
        return

    start_ts = int(last_ts.timestamp()) + 1
    end_ts = int(current_device_ts.timestamp()) - 1

    if gap > MAX_RECOVERY_WINDOW_SECONDS:
        start_ts = int(current_device_ts.timestamp()) - MAX_RECOVERY_WINDOW_SECONDS
        print(
            f"Large gap detected for {dev_eui}: {int(gap)}s. "
            f"Limiting recovery request to the last 24 hours."
        )
    request_to_send = None
    
    with pending_gaps_lock:
        existing_gap = get_pending_gap(dev_eui)

        if existing_gap:
            old_start = existing_gap["start_ts"]
            old_end = existing_gap["end_ts"]
    
            new_start = min(old_start, start_ts)
            new_end = max(old_end, end_ts)
            
            if new_end - new_start > MAX_RECOVERY_WINDOW_SECONDS:
                new_start = new_end - MAX_RECOVERY_WINDOW_SECONDS
                print(
                    f"Recovery interval for {dev_eui} exceeded 24h. "
                    f"Trimming start to {new_start}."
                )
    
            upsert_pending_gap(
                dev_eui=dev_eui,
                app_id=app_id,
                start_ts=new_start,
                end_ts=new_end,
                last_requested_at=time.time(),
                retry_count=0,
            )
    
            print(
                f"Recovery interval extended for {dev_eui}: "
                f"{old_start}-{old_end} -> {new_start}-{new_end}"
            )
            request_to_send = (app_id, dev_eui, new_start, new_end)
    
        else:
            upsert_pending_gap(
                dev_eui=dev_eui,
                app_id=app_id,
                start_ts=start_ts,
                end_ts=end_ts,
                last_requested_at=time.time(),
                retry_count=0,
            )
    
            print(f"!!! GAP DETECTED: {int(gap)}s gap for {dev_eui}. Requesting specific range.")
            request_to_send = (app_id, dev_eui, start_ts, end_ts)
            
    if request_to_send:
        send_retransmission_request(client, *request_to_send)

def check_pending_gaps_after_insert(client):
    gaps_snapshot = list_pending_gaps()

    for gap in gaps_snapshot:
        dev_eui = gap["device_eui"]
        start_ts = gap["start_ts"]
        end_ts = gap["end_ts"]

        if is_gap_filled(dev_eui, start_ts, end_ts):
            print(f"Pending recovery interval filled for {dev_eui}. Recovery request completed")
            log_event("RECOVERY_COMPLETED", f"Recovery interval {start_ts}-{end_ts} completed for {dev_eui}.")

            with pending_gaps_lock:
                delete_pending_gap(dev_eui)
        else:
            print(f"Recovery interval not filled yet for {dev_eui}.")

def is_gap_filled(dev_eui, start_ts, end_ts):
    conn = get_db_connection()
    if not conn:
        return False

    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT EXTRACT(EPOCH FROM device_timestamp)::bigint
            FROM sensor_data
            WHERE device_eui = %s
              AND device_timestamp >= to_timestamp(%s)
              AND device_timestamp <= to_timestamp(%s)
            ORDER BY device_timestamp ASC
        """, (dev_eui, start_ts, end_ts))

        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        timestamps = [row[0] for row in rows]

        if not timestamps:
            print(
                f"Recovery check for {dev_eui}: no data in requested interval "
                f"{start_ts}-{end_ts}"
            )
            return False
        print(
            f"Recovery check for {dev_eui}: "
            f"count={len(timestamps)}, min_ts={timestamps[0]}, max_ts={timestamps[-1]}, "
            f"requested={start_ts}-{end_ts}"
        )
        
        # Check beginning coverage
        if timestamps[0] - start_ts > GAP_FILL_TOLERANCE_SECONDS:
            print(
                f"Recovery not complete: missing beginning of interval "
                f"({timestamps[0] - start_ts}s after requested start)."
            )
            return False

        # Check end coverage
        if end_ts - timestamps[-1] > GAP_FILL_TOLERANCE_SECONDS:
            print(
                f"Recovery not complete: missing end of interval "
                f"({end_ts - timestamps[-1]}s before requested end)."
            )
            return False

        # Check internal gaps
        for prev_ts, next_ts in zip(timestamps, timestamps[1:]):
            if next_ts - prev_ts > GAP_FILL_TOLERANCE_SECONDS:
                print(
                    f"Recovery not complete: internal gap detected "
                    f"from {prev_ts} to {next_ts} ({next_ts - prev_ts}s)."
                )
                return False

        return True

    except Exception as e:
        print(f"Error checking gap fill: {e}")
        return False

def send_retransmission_request(client, app_id, dev_eui, start_ts, end_ts):
    if not app_id:
        msg = f"Cannot request retransmission for {dev_eui}: applicationId missing."
        print(msg)
        log_event("RECOVERY_REQUEST_FAILED", msg)
        return

    downlink_topic = f"application/{app_id}/device/{dev_eui}/command/down"
    binary_payload = struct.pack('>BII', 2, start_ts, end_ts)
    b64_payload = base64.b64encode(binary_payload).decode('utf-8')

    downlink_json = json.dumps({
        "devEui": dev_eui,
        "confirmed": False,
        "fPort": 2,
        "data": b64_payload
    })

    client.publish(downlink_topic, downlink_json)

    dk_tz = ZoneInfo("Europe/Copenhagen")
    start_dt = datetime.datetime.fromtimestamp(start_ts, datetime.timezone.utc).astimezone(dk_tz)
    end_dt = datetime.datetime.fromtimestamp(end_ts, datetime.timezone.utc).astimezone(dk_tz)

    print(
        f"Retransmit sent for {dev_eui}: "
        f"{start_dt.strftime('%Y-%m-%d %H:%M:%S %Z')} to "
        f"{end_dt.strftime('%Y-%m-%d %H:%M:%S %Z')} "
        f"(Unix: {start_ts} to {end_ts}, Base64: {b64_payload})"
    )

    log_event(
        "RECOVERY_REQUEST",
        f"Requested retransmission from {dev_eui}: {start_ts} to {end_ts}, Base64: {b64_payload}"
    )


def get_last_measurement(cursor, dev_eui):
    """Henter den seneste valide måling for en specifik enhed fra databasen."""
    query = """
        SELECT device_timestamp, ambient_temp, immediate_temp, conductor_temp, cpu_temp 
        FROM sensor_data 
        WHERE device_eui = %s 
        ORDER BY device_timestamp DESC 
        LIMIT 1
    """
    cursor.execute(query, (dev_eui,))
    return cursor.fetchone() # Returnerer (time, amb, imm, con, cpu) eller None

# --- MQTT Callbacks ---
def on_message(client, userdata, msg):
    auto_purge_old_data()
    print(f"\n--- New DLR Telemetry Received ---")
    try:
        payload_json = json.loads(msg.payload.decode('utf-8'))
        dev_eui = payload_json.get("deviceInfo", {}).get("devEui", "UNKNOWN")
        app_id = payload_json.get("deviceInfo", {}).get("applicationId")
        base64_data = payload_json.get("data", "")

        if not base64_data:
            return
        measurements, raw_payload_hex = decode_payload(base64_data)
        if not measurements:
            msg = (
                f"No valid measurements decoded from {dev_eui}. "
                f"Raw payload hex: {raw_payload_hex if raw_payload_hex else 'unavailable'}"
            )
            print(msg)
            log_event("MALFORMED_PAYLOAD", msg)
            return
        check_for_missing_data(client, dev_eui, app_id, measurements[-1][0]) #gap detection på nyeste measurement ikke buffer data

        print(f"\n--- Processing {len(measurements)} measurements from {dev_eui} ---")
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            saved_count = 0
            last_vals = get_last_measurement(cursor, dev_eui)
            for dt, amb, imm, con, cpu, m_hex in measurements:
                try:
                    ts_unix = dt.timestamp()
                    current_time = time.time()
                    if ts_unix < MIN_VALID_TIME:
                        error_msg = f"Rejected: Timestamp is in the past (Epoch error: {dt})"
                        print(f"{error_msg}")
                        log_event("TIME_ANOMALY", error_msg)
                        continue
                    elif ts_unix > (current_time + MAX_FUTURE_BUFFER):
                        error_msg = f"Rejected: Future timestamp ({dt}). Server time is {datetime.datetime.now()}"
                        print(f"{error_msg}")
                        log_event("TIME_ANOMALY", error_msg)
                        continue
                    
                    all_temps = [amb, imm, con, cpu]
                    
                    if any (t < TEMP_LIMIT_MIN or t > TEMP_LIMIT_MAX for t in all_temps):
                        warn_msg = (f"Rejected record from {dev_eui}: Out of bounds detected. "
                                    f"Values: Amb:{amb}, Imm:{imm}, Con:{con}, CPU:{cpu}")
                        print(f"{warn_msg}")
                        log_event("SANITY_REJECTION", warn_msg)
                        continue

                    if last_vals and ts_unix > last_vals[0].timestamp():
                        last_ts = last_vals[0].timestamp()
                        last_amb = float(last_vals[1])
                        time_delta = (ts_unix - last_ts) / 60
                        jump = abs(amb - last_amb)

                        # if measurements with time_delta < 1 min
                        effective_min = max(time_delta, 1.0)
                        allowed_jump = effective_min * MAX_TEMP_JUMP_PER_MINUTE 
                        dynamic_limit = min(allowed_jump, 80.0) # wont accept crazy changes
                        if jump > dynamic_limit:
                            warn_msg = (f"Rejected record from {dev_eui}: Sudden jump detected! "
                                        f"Changed {jump}°C over {round(time_delta, 2)} min. "
                                        f"Max allowed for this gap: {round(dynamic_limit, 2)}°C")
                            print(f"{warn_msg}")
                            log_event("JUMP_ANOMALY", warn_msg)
                            continue
                    # ON CONFLICT DO NOTHING sørger for at redundante data sorteres fra
                    insert_query = """
                        INSERT INTO sensor_data
                        (device_eui, device_timestamp, ambient_temp, immediate_temp, conductor_temp, cpu_temp, raw_payload)
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT ON CONSTRAINT unique_measurement DO NOTHING
                    """
                    cursor.execute(insert_query, (dev_eui, dt, amb, imm, con, cpu, m_hex))
                    if cursor.rowcount > 0:
                        saved_count +=1
                        last_vals = (dt, amb, imm, con, cpu)
                    conn.commit()
                except Exception as inner_e:
                    print(f"Failed to insert one measurement: {inner_e}")
                    conn.rollback()

            cursor.close()
            conn.close()
            if saved_count >0:
                print("Data successfully saved to database.")
                check_pending_gaps_after_insert(client)
            else:
                print("No new measurements were saved (due to errors or duplicates)")

    except Exception as e:
        print(f"Error processing message: {e}")

def recovery_retry_loop(client):
    """
    Periodically checks pending recovery intervals stored in PostgreSQL.
    If a gap is still not filled after RECOVERY_RETRY_AFTER_SECONDS,
    the retransmission request is sent again.
    After MAX_RECOVERY_RETRIES, the system gives up and logs the failure.
    """
    while True:
        time.sleep(PENDING_GAP_CHECK_INTERVAL)
        now = time.time()

        gaps_snapshot = list_pending_gaps()

        for gap in gaps_snapshot:
            dev_eui = gap["device_eui"]
            app_id = gap["app_id"]
            start_ts = gap["start_ts"]
            end_ts = gap["end_ts"]
            last_requested_at = gap.get("last_requested_at", 0)
            retry_count = gap.get("retry_count", 0)

            if is_gap_filled(dev_eui, start_ts, end_ts):
                print(f"Pending recovery interval filled for {dev_eui}. Recovery request completed")
                log_event(
                    "RECOVERY_COMPLETED",
                    f"Recovery interval {start_ts}-{end_ts} completed for {dev_eui}."
                )

                with pending_gaps_lock:
                    delete_pending_gap(dev_eui)

                continue

            seconds_since_request = now - last_requested_at

            if seconds_since_request < RECOVERY_RETRY_AFTER_SECONDS:
                continue

            if retry_count >= MAX_RECOVERY_RETRIES:
                msg = (
                    f"Recovery failed for {dev_eui}: interval {start_ts}-{end_ts} "
                    f"was not filled after {MAX_RECOVERY_RETRIES} retries. "
                    f"Giving up."
                )
                print(msg)
                log_event("RECOVERY_FAILED", msg)

                with pending_gaps_lock:
                    delete_pending_gap(dev_eui)

                continue

            new_retry_count = retry_count + 1

            print(
                f"Retrying recovery request for {dev_eui}. "
                f"Attempt {new_retry_count}/{MAX_RECOVERY_RETRIES}. "
                f"Interval: {start_ts}-{end_ts}"
            )

            send_retransmission_request(client, app_id, dev_eui, start_ts, end_ts)

            with pending_gaps_lock:
                upsert_pending_gap(
                    dev_eui=dev_eui,
                    app_id=app_id,
                    start_ts=start_ts,
                    end_ts=end_ts,
                    last_requested_at=now,
                    retry_count=new_retry_count,
                )
                    
def main():
    print("Starting Application Server MQTT Listener...")

    # Initialize MQTT Client
    client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2, client_id="scada_mqtt_listener_docker_v1")
    client.tls_set(ca_certs=CA_CERT_PATH)
    client.tls_insecure_set(False)
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message

    try:
        client.connect(MQTT_BROKER, MQTT_PORT, 60)

        retry_thread = threading.Thread(
            target=recovery_retry_loop,
            args=(client,),
            daemon=True
        )
        retry_thread.start()
        
        client.loop_forever()
    except KeyboardInterrupt:
        print("\nShutting down Application Server...")
        client.disconnect()
    except Exception as e:
        print(f"Connection error: {e}")

if __name__ == "__main__":
    main()
