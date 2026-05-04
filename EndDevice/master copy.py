import serial
import time
import datetime
import RPi.GPIO as GPIO
import os
import sqlite3

# --- Configuration ---
SERIAL_PORT = '/dev/serial0'
BAUD_RATE = 115200
RST_PIN = 18
AT_TIMEOUT = 2.0         # Seconds the watchdog waits for an "OK"
MAX_FAILURES = 3         # Number of missed heartbeats before hardware reset
SEND_INTERVAL = 30       # Seconds between each LoRa transmission (Duty Cycle)

# --- Setup GPIO ---
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(RST_PIN, GPIO.OUT, initial=GPIO.HIGH)

BUFFER_DB = "/home/pi3/buffer.db"
last_payload = "0" * 24


def payload_timestamp(payload):
    """Returns Unix timestamp extracted from the first 4 bytes (8 hex chars)."""
    return int(payload[0:8], 16)


def init_buffer_db():
    """Creates local SQLite buffer database if needed."""
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


def get_buffer_payloads_between(start_ts, end_ts):
    """Returns payloads in timestamp range, ordered from oldest to newest."""
    conn = sqlite3.connect(BUFFER_DB)
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT payload FROM readings
        WHERE timestamp >= ? AND timestamp <= ?
        ORDER BY timestamp ASC
        """,
        (start_ts, end_ts),
    )
    rows = cursor.fetchall()
    conn.close()
    return [row[0] for row in rows]

def clear_buffer():
    """Removes all buffered payloads from SQLite."""
    conn = sqlite3.connect(BUFFER_DB)
    cursor = conn.cursor()
    cursor.execute("DELETE FROM readings")
    conn.commit()
    conn.close()

def reset_rak_module():
    """Forces a hardware restart of the RAK module via the GPIO pin."""
    print("\n--- PERFORMING HARDWARE RESET ---")
    GPIO.output(RST_PIN, GPIO.LOW)
    time.sleep(3)   # Hold RST low for 3 seconds
    GPIO.output(RST_PIN, GPIO.HIGH)
    time.sleep(5)   # Allow the module 5 seconds to boot up
    print("--- RESET COMPLETE ---\n")

def is_lora_alive(lora_serial):
    """Sends 'AT' up to 3 times and returns True if 'OK' is received."""
    for attempt in range(3):
        lora_serial.reset_input_buffer()
        lora_serial.write(b'AT\r\n')
        time.sleep(1)
        if lora_serial.in_waiting > 0:
            response = lora_serial.read_all().decode(errors='ignore').strip()
            if "OK" in response:
                return True
        time.sleep(0.5)
    return False

def sync_pi_time(lora_serial):
    """Fetches Time from RAK and updates Raspberry PI system time"""
    lora_serial.write(b'AT+LTIME=?\r\n')
    time.sleep(0.5)
    res = ""
    if lora_serial.in_waiting > 0:
        res = lora_serial.read_all().decode(errors='ignore').strip()
        print(f"RAK LTIME response: {res}")
        
        try:
            if "=" in res:
                time_part = res.split('=')[1].split('\n')[0].strip()
                dt_obj = datetime.datetime.strptime(time_part, "%Hh%Mm%Ss on %m/%d/%Y")
                formatted_time = dt_obj.strftime("%Y-%m-%d %H:%M:%S")
                os.system(f"sudo date -s '{formatted_time} UTC'")
                print(f"System Clock Synced to UTC: {formatted_time}")
            else:
                print(f"could not find '=' in response")
        except Exception as e:
            print(f"Failed to parse LTIME: {e}")
    else:
        print(f"NO response from RAK module during LTIME request")

def lora_setup_connection(lora_serial):
    """Initializes LoRaWAN OTAA session."""
    lora_serial.read_all()
    lora_serial.write(b'AT+BAND=4\r\n') # EU868
    time.sleep(0.5)
    lora_serial.write(b'AT+NWM=1\r\n')  # LoRaWAN mode
    time.sleep(0.5)
    lora_serial.write(b'AT+NJM=1\r\n')  # OTAA mode
    time.sleep(0.5)

    # Check join status
    lora_serial.write(b'AT+NJS=?\r\n')
    time.sleep(1)
    response = lora_serial.read_all().decode(errors='ignore')

    if "1" in response and not "0" in response:
        print("Device already joined. Skipping join process.")
        return True

    print("Not joined. Attempting OTAA Join...")
    lora_serial.write(b'AT+JOIN=1:1:10:8\r\n')
    start_time = time.time()
    while time.time() - start_time < 20: # Extended join wait
        if lora_serial.in_waiting > 0:
            res = lora_serial.read_all().decode(errors='ignore')
            if "JOINED" in res:
                print("OTAA join successful!")
                lora_serial.write(b'AT+SAVE\r\n')
                return True
        time.sleep(1)
    return False


def get_combined_payload():
    """Constructs a payload from new buffered readings (12-byte multiples, up to 48 bytes)."""
    global last_payload

    last_ts = -1
    if last_payload and last_payload != ("0" * 24):
        last_ts = payload_timestamp(last_payload)

    conn = sqlite3.connect(BUFFER_DB)
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT payload FROM readings
        WHERE timestamp > ?
        ORDER BY timestamp ASC
        LIMIT 4
        """,
        (last_ts,),
    )
    rows = cursor.fetchall()
    conn.close()

    if not rows:
        return None

    payloads = [row[0] for row in rows]
    final_payload = "".join(payloads)

    last_payload = payloads[-1]
    return final_payload

def send_payload_and_listen(lora_serial, hex_payload):
    """Transmits data and listens for Class A Downlink commands."""
    lora_serial.read_all()
    if len(hex_payload) > 102: # 102 hex chars = 51 bytes
        print("Warning: Payload might be too large for high Spreading Factors!")
    lora_serial.write(f"AT+SEND=2:{hex_payload}\r\n".encode())

    start_wait = time.time()
    while time.time() - start_wait < 12: # Class A RX1/RX2 window
        if lora_serial.in_waiting > 0:
            line = lora_serial.readline().decode(errors='ignore').strip()
            if "+EVT:TIMEREQ_OK" in line:
                print(f"Time Request Successful!")
                sync_pi_time(lora_serial)
            if "+EVT:RX" in line:
                print(f"Downlink detected!")
                parts = line.split(':')
                if len(parts) >= 6:
                    downlink_hex = parts[-1].strip()
                    handle_downlink(downlink_hex, lora_serial)
                return True
        time.sleep(0.1)
    return False

def handle_downlink(hex_cmd, lora_serial):
    """Executes commands received from Network Server."""
    cmd = hex_cmd.strip().upper()
    if cmd.startswith("02") and len(cmd) == 18:
        try:
            start_ts = int(hex_cmd[2:10], 16)
            end_ts = int(hex_cmd[10:18], 16)
            print(f"ACTION: Server requested buffer data between {start_ts} to {end_ts}.")
            payloads = get_buffer_payloads_between(start_ts, end_ts)

            # Stream requested payloads (oldest-first), skipping those already sent
            idx = 0
            while idx < len(payloads):
                packet = ""
                base = get_combined_payload()
                if base: packet = base
                # try to append to current packet, ensure <= 96 hex chars (48 bytes)
                while idx < len(payloads) and len(packet) + len(payloads[idx]) <= 96:
                    packet += payloads[idx]
                    idx += 1

                # send current packet, then start new one with p
                print(f"📦 Sending packet: {packet}")
                lora_serial.write(f"AT+SEND=2:{packet}\r\n".encode())
                time.sleep(5)

        except Exception as e:
            print(f"Error during buffer dump: {e}")
    elif cmd.startswith("03"):
        print("ACTION: Server confirmed data receipt. Clearing buffer...")
        clear_buffer()
        print("Buffer cleared from database.")


def main():
    consecutive_failures = 0
    last_sync_date = None
    print("DLR Sensor Node Active...")
    init_buffer_db()

    try:
        lora_serial = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=AT_TIMEOUT)
    except Exception as e:
        print(f"Serial Error: {e}")
        return

    if not is_lora_alive(lora_serial):
        reset_rak_module()
    lora_setup_connection(lora_serial)

    while True:
        if is_lora_alive(lora_serial):
            consecutive_failures = 0
            current_date = datetime.date.today()

            if last_sync_date != current_date:
                print(f"New day registered ({current_date}). Requesting time...")
                lora_serial.write(b'AT+TIMEREQ=1\r\n')
                time.sleep(0.5)
                last_sync_date = current_date
                clear_buffer()
                print("Daily cleanup: Buffer database cleared.")

            lora_serial.read_all()
            lora_serial.write(b'AT+NJS=?\r\n')
            time.sleep(1.0)
            if "1" in lora_serial.read_all().decode(errors='ignore'):
                payload = get_combined_payload()
                if payload:
                    payload_parts = [payload[i:i+24] for i in range(0, len(payload), 24)]
                    print(f"SENDING {len(payload_parts)} reading(s): {payload_parts}")
                    send_payload_and_listen(lora_serial, payload)
                else:
                    print("No new buffered payloads to transmit.")
            else:
                print("Connection lost. Saving to buffer and re-joining...")
                lora_setup_connection(lora_serial)

            time.sleep(SEND_INTERVAL)
        else:
            consecutive_failures += 1
            if consecutive_failures >= MAX_FAILURES:
                reset_rak_module()
                lora_setup_connection(lora_serial)
                consecutive_failures = 0
            time.sleep(2)

if __name__ == "__main__":
    try:
        main()
    finally:
        GPIO.cleanup()
