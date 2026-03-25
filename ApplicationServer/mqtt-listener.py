import paho.mqtt.client as mqtt
import psycopg2
import json
import base64
import struct
import datetime
import time

# MQTT Broker (ChirpStack Mosquitto)
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
# Listen to all uplink events from all applications and devices
MQTT_TOPIC = "application/+/device/+/event/up"

# PostgreSQL SCADA Database
DB_HOST = "localhost"
DB_PORT = "5433" # mapped in docker-compose
DB_NAME = "powerline_telemetry"
DB_USER = "app_user"
DB_PASS = "IMbachelor26"
last_cleanup_date = None
last_seen = {}
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
    client.subscribe(MQTT_TOPIC)

# --- Payload Decoding Logic ---
def decode_payload(base64_data):
    try:
        raw_bytes = base64.b64decode(base64_data)
        measurements = []
        for i in range(0, len(raw_bytes), 8):
            block = raw_bytes[i:i+8]

            if len(block) == 8 and block != b'\x00' * 8:
                vals = struct.unpack('>hhhh', block)
                t_amb = vals[0] / 10.0
                t_imm = vals[1] / 10.0
                t_con = vals[2] / 10.0
                t_cpu = vals[3] / 10.0
                measurements.append((t_amb, t_imm, t_con, t_cpu))

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
                query = "DELETE FROM sensor_data WHERE received_at < NOW() - INTERVAL '30 days';"
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

def check_for_missing_data(client, dev_eui, application_id):
    current_time = time.time()
    if dev_eui in last_seen:
        elapsed = current_time - last_seen[dev_eui]
        if elapsed > 45:
            print(f"!!! WARNING: Cap detected for {dev_eui}. Missing data for {int(elapsed)} sec.")
            send_retransmission_request(client, application_id, dev_eui)
    last_seen[dev_eui] = current_time

def send_retransmission_request(client, app_id, dev_eui):
    downlink_topic = f"application/{app_id}/device/{dev_eui}/command/down"
    downlink_payload = json.dumps({
        "devEui": dev_eui,
        "confirmed": False,
        "fPort": 2,
        "data": "AQ=="
    })
    client.publish(downlink_topic, downlink_payload)
    print(f"Downlink send: Request of retransmission send to {dev_eui}")

# --- MQTT Callbacks ---
def on_message(client, userdata, msg):
    auto_purge_old_data()
    print(f"\n--- New DLR Telemetry Received ---")
    try:
        payload_json = json.loads(msg.payload.decode('utf-8'))
        dev_eui = payload_json.get("deviceInfo", {}).get("devEui", "UNKNOWN")
        app_id = payload_json.get("deviceInfo", {}).get("applicationId")
        base64_data = payload_json.get("data", "")
        check_for_missing_data(client, dev_eui, app_id)

        if not base64_data:
            return
        measurements, raw_hex = decode_payload(base64_data)

        if measurements:
            print(f"\n--- Processing {len(measurements)} measurements from {dev_eui} ---")
            conn = get_db_connection()
            if conn:
                cursor = conn.cursor()
                for amb, imm, con, cpu in measurements:
                    try:
                        # ON CONFLICT DO NOTHING sørger for at redundante data sorteres fra
                        insert_query = """
                            INSERT INTO sensor_data
                            (device_eui, ambient_temp, immediate_temp, conductor_temp, cpu_temp, raw_payload)
                            VALUES (%s, %s, %s, %s, %s, %s)
                            ON CONFLICT ON CONSTRAINT unique_measurement DO NOTHING
                        """
                        cursor.execute(insert_query, (dev_eui, amb, imm, con, cpu, raw_hex))
                        conn.commit()
                    except Exception as inner_e:
                        print(f"Failed to insert one measurement: {inner_e}")
                        conn.rollback()

                cursor.close()
                conn.close()
                print("Aggregated Data successfully saved to database.")

    except Exception as e:
        print(f"Error processing message: {e}")

def main():
    print("Starting Application Server MQTT Listener...")

    # Initialize MQTT Client
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
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
