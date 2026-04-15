import serial
import time
import random
import RPi.GPIO as GPIO
import csv
import os

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

BUFFER_FILE = "buffer.csv"
last_payload = "0000000000000000"

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
        if lora_serial.in_waiting >0:
            raw_data = lora_serial.read_all()
            response_text = raw_data.decode(errors='ignore').strip()

            if "OK" in response_text:
                return True
            else:
                # Log hvad vi rent faktisk fik, så vi kan se fejlen
                print(f"Watchdog: Got unexpected string: '{response_text}'")

        print(f"Watchdog: Attempt {attempt + 1}/3 failed")
        time.sleep(0.5)

    return False

def lora_setup_connection(lora_serial):
    """
    Configures the LoRaWAN connection.
    Uses OTAA as primary and sets parameters to avoid constant re-joins.
    """
    lora_serial.write(b'AT+BAND=4\r\n') # EU868
    time.sleep(0.5)
    # Set to OTAA mode (1 = OTAA, 0 = ABP)
    lora_serial.write(b'AT+NWM=1\r\n') # LoRaWAN mode
    time.sleep(0.5)
    lora_serial.write(b'AT+NJM=1\r\n') # OTAA mode
    time.sleep(0.5)

    # Check if we are already joined to avoid generating new keys unnecessarily
    lora_serial.write(b'AT+NJS=?\r\n')
    time.sleep(1)
    response = lora_serial.read_all().decode(errors='ignore')

    if "1" in response: # 1 means already joined
        print("Device already joined. Skipping join process.")
        return True

    print("Not joined. Attempting OTAA Join...")
    lora_serial.write(b'AT+JOIN=1:1:10:8\r\n') # Join med auto-retry
    start_time = time.time()
    while time.time() - start_time < 15:
        if lora_serial.in_waiting > 0:
            res = lora_serial.read_all().decode(errors='ignore')
            if "JOINED" in res or "OK" in res:
                print("OTAA join successful!")
                lora_serial.write(b'AT+SAVE\r\n')
                return True
        time.sleep(1)
    print("OTAA Join failed (Timeout/No Network).")
    return False

def get_pi_cpu_temp():
    """ Read the physical CPU-temperature of the Raspberry Pi's chip"""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            # Value is in milli-degress (fx 45000 = 45.0 degress)
            return float(f.read().strip()) / 1000.0
    except Exception as e:
        print(f"Couldn't read CPU temp {e}")
        return 40.0 # Standard fallback

def save_to_buffer(payload):
    """ Saves data locally in case LoRa-module fails og network fails """
    file = os.path.isfile(BUFFER_FILE)
    with open(BUFFER_FILE, mode='a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([time.strftime("%Y-%m-%d %H:%M:%S"), payload])
    print(f"CRITICAL: Data saved to local buffer ({BUFFER_FILE})")

def get_hex_data():
    cpu_temp = get_pi_cpu_temp()
    ambient_temp = cpu_temp - 25.0 # temp outside
    immediate_temp = ambient_temp + random.uniform(2.0, 5.0) # temp of air around power-line
    conductor_temp = immediate_temp + random.uniform(30.0, 50.0) # temp inside power-line

    print(f"\n--- New measurements ---")
    print(f"Outside Temp:       {ambient_temp:.1f} °C")
    print(f"Around Temp:  {immediate_temp:.1f} °C")
    print(f"Inside Temp:    {conductor_temp:.1f} °C")
    print(f"CPU Temp:     {cpu_temp:.1f} °C")

    t_amb = int(ambient_temp * 10)
    t_imm = int(immediate_temp * 10)
    t_con = int(conductor_temp * 10)
    t_cpu = int(cpu_temp * 10)

    payload = f"{(t_amb & 0xFFFF):04X}{(t_imm & 0xFFFF):04X}{(t_con & 0xFFFF):04X}{(t_cpu & 0xFFFF):04X}"

    print(f"Hex Payload: {payload}")
    return payload

def send_sensor_data(lora_serial):
    """Generates simulated telemetry data and transmits it."""
    hex_data = get_hex_data()

    lora_serial.reset_input_buffer()
    lora_serial.write(f"AT+SEND=2:{payload}\r\n".encode())
    time.sleep(2)
    response = lora_serial.read_all().decode(errors='ignore')
    if "OK" in response:
        print(f"Transmission successful: {response.strip()}")
        return True
    else:
        save_to_buffer(payload)
        return False

def get_combined_payload():
    global last_payload
    current_payload = get_hex_data()
    buffer_payloads = []
    if os.path.isfile(BUFFER_FILE):
        with open(BUFFER_FILE, mode='r') as f:
            rows = list(csv.reader(f))
            for i in range(min(len(rows), 2)):
                buffer_payloads.append(rows[i][1])
        remaining = rows[2:] if len(rows) > 2 else []
        if remaining:
            with open(BUFFER_FILE, mode='w', newline='') as f:
                csv.writer(f).writerows(remaining)
        else:
            os.remove(BUFFER_FILE)
    final_payload = current_payload + last_payload
    for i in range(2):
        if i < len(buffer_payloads):
            final_payload += buffer_payloads[i]
        else:
            final_payload += "0000000000000000"

    last_payload = current_payload
    return final_payload

def send_payload_and_listen(lora_serial, hex_payload):
    # Send på Port 2
    lora_serial.read_all()
    command = f"AT+SEND=2:{hex_payload}\r\n"
    lora_serial.write(command.encode())

    # LoRaWAN Class A lytter kun i ca. 5 sekunder efter send

    start_wait = time.time()
    found_rx = False
    while time.time() - start_wait < 8:
        if lora_serial.in_waiting > 0:
            response = lora_serial.read_all().decode(errors='ignore').strip()
            for line in response.split('\n'):
                line = line.strip()
                if not line:
                    continue
                print(f"Modul answer: {line}")

                # Tjek om der er en indkommende besked (Downlink)
                if "+EVT:RX" in response:
                    # Formatet er ofte +EVT:RX:<PORT>:<HEX_DATA>
                    parts = line.split(':')
                    if len(parts) >= 7:
                        port = parts[5]
                        received_hex = parts[6]
                        print(f"--- DOWNLINK VERIFIED ---")
                        print(f"Port: {port}")
                        print(f"Data (Hex): {received_hex}")
                        handle_downlink(received_hex, lora_serial)
                        found_rx = True
        time.sleep(0.1)
    if not found_rx:
        print("No downlink received")

    return found_rx


def handle_downlink(hex_cmd, lora_serial):
    if hex_cmd == "01":
        print("ACTION: Server requests retransmission!")
        if os.path.isfile(BUFFER_FILE):
            with open(BUFFER_FILE, mode='r') as f:
                rows = list(csv.reader(f))
            print(f"Sending {len(rows)} buffer-messages...")
            for timestamp, payload in rows:
                print(f"Retransmitting: {timestamp}")
                lora_serial.write(f"AT+SEND=2:{payload}\r\n".encode())
                time.sleep(4)
            os.remove(BUFFER_FILE)
            print("Buffer empty")
            pass
        else:
            print("Buffer is already empty")

def process_buffer(lora_serial):
    """Tries to send buffered data when online again"""
    if not os.path.isfile(BUFFER_FILE):
        return
    rows = []

    with open(BUFFER_FILE, mode='r') as f:
        rows = list(csv.reader(f))
    if not rows:
        if os.path.exists(BUFFER_FILE):
            os.remove(BUFFER_FILE)
            return

    timestamp, payload = rows[0]
    print(f"Sending buffer data from {timestamp}...")
    lora_serial.write(f"AT+SEND=2:{payload}\r\n".encode())
    time.sleep(4)
    response = lora_serial.read_all().decode(errors='ignore')
    if "OK" in response:
        print("Buffer data send successfully")
        remaining_rows = rows[1:]
        if remaining_rows:
            with open(BUFFER_FILE, mode='w', newline='') as f:
                writer = csv.writer(f)
                writer.writerows(remaining_rows)
        else:
            os.remove(BUFFER_FILE)
    else:
        print("Buffer data not send, waiting ..")


def main():
    consecutive_failures = 0

    print("Starting Autonomous Sensor Firmware...")

    try:
        lora_serial = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=AT_TIMEOUT)
    except Exception as e:
        print(f"Error: Could not open serial port {SERIAL_PORT}: {e}")
        return

    if not is_lora_alive(lora_serial):
        reset_rak_module()
    lora_setup_connection(lora_serial)

    # Main system loop
    while True:
        # CHECK 1: Is the module awake and responsive?
        if is_lora_alive(lora_serial):
            consecutive_failures = 0 # Reset the failure counter
            lora_serial.write(b'AT+NJS=?\r\n')
            time.sleep(1.0)
            status_response = lora_serial.read_all().decode(errors='ignore')

print(f"Debug: NJS response was '{status_response.strip()}'")

            if "1" in status_response:1~print(f"Debug: NJS response was '{status_response.strip()}'")

            if "1" in status_response:print(f"Debug: NJS response was '{status_response.strip()}'")

            if "1" in status_response:                aggregated_payload = get_combined_payload()
                print(f"Sending Aggregated Payload: {aggregated_payload}")
                send_payload_and_listen(lora_serial, aggregated_payload)
            else:
                print("Device lost connection (NJS=0). Re-joining...")
                lora_setup_connection(lora_serial)

            print(f"Waiting {SEND_INTERVAL} seconds...\n---------------------------")
            time.sleep(SEND_INTERVAL)

        else:
            # Error handling: The module is unresponsive!
            consecutive_failures += 1
            print(f"Watchdog: Failure count = {consecutive_failures}")

            if consecutive_failures >= MAX_FAILURES:
                print(f"Watchdog Failure {consecutive_failures}/{MAX_FAILURES}")
                reset_rak_module()
                time.sleep(5)
                lora_setup_connection(lora_serial)
                consecutive_failures = 0

            # If the check failed, wait a short moment before trying to wake it again
            time.sleep(2)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nScript stopped by user.")
    finally:
        GPIO.cleanup()
