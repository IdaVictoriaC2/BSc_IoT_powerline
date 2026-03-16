import paho.mqtt.client as mqtt
import psycopg2
import json
import base64
import struct
import datetime

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
    if reason_code == 0:
        print(f"Connected to MQTT Broker at {MQTT_BROKER}:{MQTT_PORT}")
        client.subscribe(MQTT_TOPIC)
        print(f"Subscribed to topic: {MQTT_TOPIC}")
        log_event("MQTT_CONNECTED", "Listener established connection to Mosquitto Broker")
    else:
        print(f"Failed to connect to MQTT Broker. Return code: {reason_code}")

# --- Payload Decoding Logic ---
def decode_payload(base64_data):
    try:
        raw_bytes = base64.b64decode(base64_data)
        if len(raw_bytes) == 8:
            # Manuel parsing baseret på jeres hex-mønster
            status = raw_bytes[0]
            t_amb = raw_bytes[1] / 10.0
            t_imm = int.from_bytes(raw_bytes[2:4], byteorder='big', signed=True) / 10.0
            t_con = int.from_bytes(raw_bytes[4:6], byteorder='big', signed=True) / 10.0
            t_cpu = int.from_bytes(raw_bytes[6:8], byteorder='big', signed=True) / 10.0

            return t_amb, t_imm, t_con, t_cpu, raw_bytes.hex()
        return None, None, None, None, raw_bytes.hex()
    except Exception as e:
        print(f"Error decoding: {e}")
        return None, None, None, None, str(base64_data)

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

# --- MQTT Callbacks ---
def on_message(client, userdata, msg):
    auto_purge_old_data()
    print(f"\n--- New DLR Telemetry Received ---")
    try:
        payload_json = json.loads(msg.payload.decode('utf-8'))
        dev_eui = payload_json.get("deviceInfo", {}).get("devEui", "UNKNOWN")
        base64_data = payload_json.get("data", "")

        if not base64_data:
            return

        # Udpak de 4 nye temperaturer
        ambient, immediate, conductor, cpu, raw_hex = decode_payload(base64_data)

        if ambient is not None:
            print(f"DevEUI: {dev_eui} | Hex: {raw_hex}")
            print(f"Amb: {ambient}C, Imm: {immediate}C, Con: {conductor}C, CPU: {cpu}C")

            # Gem i den nye tabelstruktur
            conn = get_db_connection()
            if conn:
                cursor = conn.cursor()
                insert_query = """
                    INSERT INTO sensor_data (device_eui, ambient_temp, immediate_temp, conductor_temp, cpu_temp, raw_payload)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(insert_query, (dev_eui, ambient, immediate, conductor, cpu, raw_hex))
                conn.commit()
                cursor.close()
                conn.close()
                print("DLR Data successfully saved to database.")

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
