import paho.mqtt.client as mqtt
import psycopg2
import json
import base64
import struct
import datetime
import time
from zoneinfo import ZoneInfo

# MQTT Broker (ChirpStack Mosquitto)
MQTT_BROKER = "localhost"
MQTT_PORT = 8883
# Listen to all uplink events from all applications and devices
MQTT_TOPIC = "application/+/device/+/event/up"

# PostgreSQL SCADA Database
DB_HOST = "localhost"
DB_PORT = "5433" # mapped in docker-compose
DB_NAME = "powerline_telemetry"
DB_USER = "app_user"
DB_PASS = "IMbachelor26"
last_cleanup_date = None

TEMP_LIMIT_MAX = 150
TEMP_LIMIT_MIN = -40
MAX_TEMP_JUMP_PER_MINUTE = 5.0
MIN_VALID_TIME = 1767225600  # 2026-01-01 00:00:00
MAX_FUTURE_BUFFER = 60     # 60 sec

pending_gaps = {}
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

def log_event(event_type, description):
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO audit_log (event_type, description) VALUES (%s, %s)", (event_type, description))
        conn.commit()
        cursor.close()
        conn.close()

# --- MQTT Callbacks ---
def on_connect(client, userdata, flags, reason_code, properties):
    """Callback for when the client receives a CONNACK response from the server."""
    print(f"Connected to MQTT, listening at {MQTT_TOPIC}")
    client.subscribe(MQTT_TOPIC, qos=1)

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
                query = "DELETE FROM sensor_data WHERE server_timestamp < NOW() - INTERVAL '30 days';"
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
    if last_record:
        last_ts = last_record[0]
        if last_ts.tzinfo is None:
            last_ts = last_ts.replace(tzinfo=datetime.timezone.utc)
        if current_device_ts.tzinfo is None:
            current_device_ts = current_device_ts.replace(tzinfo=datetime.timezone.utc)
        gap = (current_device_ts.timestamp() - last_ts.timestamp())
        if gap > 45:
            start_ts = int(last_ts.timestamp()) +1
            end_ts = int(current_device_ts.timestamp())-1
            gap_key = (dev_eui, start_ts, end_ts)
            if gap_key not in pending_gaps:
                pending_gaps[gap_key]={"app_id": app_id, "requested_at": time.time()}
                print(f"!!! GAP DETECTED: {int(gap)}s gap for {dev_eui}. Requesting specific range.")
                send_retransmission_request(client, app_id, dev_eui, start_ts, end_ts)

def check_pending_gaps_after_insert(client):
    for gap_key in list(pending_gaps.keys()):
        dev_eui, start_ts, end_ts = gap_key
        app_id = pending_gaps[gap_key]["app_id"]

        if is_gap_filled(dev_eui, start_ts, end_ts):
            print(f"Pending gap filled for {dev_eui}. Sending ACK 03 / clear buffer.")
            send_clear_buffer_command(client, app_id, dev_eui)
            pending_gaps.pop(gap_key, None)
        else:
            print(f"Gap not filled yet for {dev_eui}.")

def send_clear_buffer_command(client, app_id, dev_eui):
    """Sender kommando 03 (Base64: Aw==) via MQTT."""
    if not app_id:
        print("Cannot send ACK 03: applicationId missing.")
        return

    topic = f"application/{app_id}/device/{dev_eui}/command/down"

    payload = json.dumps({
        "devEui": dev_eui,
        "confirmed": False,
        "fPort": 2,
        "data": "Aw=="
    })

    client.publish(topic, payload)
    print(f"ACK 03 sent for {dev_eui}. Clear buffer command sent.")
    print(f"ACK 03 topic: {topic}")
    print(f"ACK 03 payload: {payload}")

def is_gap_filled(dev_eui, start_ts, end_ts):
    conn = get_db_connection()
    if not conn:
        return False

    try:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT COUNT(*)
            FROM sensor_data
            WHERE device_eui = %s
              AND device_timestamp >= to_timestamp(%s)
              AND device_timestamp <= to_timestamp(%s)
        """, (dev_eui, start_ts, end_ts))

        count = cursor.fetchone()[0]
        cursor.close()
        conn.close()

        expected_min_count = max(1, int((end_ts - start_ts) / 30))

        return count >= expected_min_count

    except Exception as e:
        print(f"Error checking gap fill: {e}")
        return False

def send_retransmission_request(client, app_id, dev_eui, start_ts, end_ts):
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
        measurements, _ = decode_payload(base64_data)
        if not measurements:
            print("No valid measurements decoded.")
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

def main():
    print("Starting Application Server MQTT Listener...")

    # Initialize MQTT Client
    client = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2, client_id="scada_app_server_v1")
    ca_cert_path = "../chirpstack-docker/configuration/certs/ca.pem"
    client.tls_set(ca_certs=ca_cert_path)
    client.tls_insecure_set(True)
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        client.connect(MQTT_BROKER, MQTT_PORT, 60)
        # Blocking call that processes network traffic, dispatches callbacks and handles reconnecting.
        client.loop_forever()
    except KeyboardInterrupt:
        print("\nShutting down Application Server...")
        client.disconnect()
    except Exception as e:
        print(f"Connection error: {e}")

if __name__ == "__main__":
    main()
