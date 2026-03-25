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
        if lora_serial.in_waiting > 0:
            response = lora_serial.read_all().decode(errors='ignore').strip()
            if "OK" in response:
                return True
        time.sleep(0.5)
    return False

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

def get_pi_cpu_temp():
    """ Read the physical CPU-temperature of the Raspberry Pi's chip"""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            # Value is in milli-degress (fx 45000 = 45.0 degress)
            return float(f.read().strip()) / 1000.0
    except:
        return 40.0 # Standard fallback

def save_to_buffer(payload):
    """ Saves data locally in case LoRa-module fails og network fails """
    file = os.path.isfile(BUFFER_FILE)
    with open(BUFFER_FILE, mode='a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([time.strftime("%Y-%m-%d %H:%M:%S"), payload])
    print(f"CRITICAL: Data saved to local buffer ({BUFFER_FILE})")

def get_hex_data():
    """Generates 8-byte (4x16-bit) sensor payload."""
    cpu_temp = get_pi_cpu_temp()
    amb = cpu_temp - 25.0
    imm = amb + random.uniform(2.0, 5.0)
    con = imm + random.uniform(30.0, 50.0)

    t_amb, t_imm, t_con, t_cpu = int(amb*10), int(imm*10), int(con*10), int(cpu_temp*10)
    return f"{(t_amb & 0xFFFF):04X}{(t_imm & 0xFFFF):04X}{(t_con & 0xFFFF):04X}{(t_cpu & 0xFFFF):04X}"

def get_combined_payload():
    """Constructs 32-byte aggregated payload (Current + Last + 2 Buffer)."""
    global last_payload
    current_payload = get_hex_data()
    buffer_payloads = []

    if os.path.isfile(BUFFER_FILE):
        with open(BUFFER_FILE, mode='r') as f:
            rows = list(csv.reader(f))
            for i in range(min(len(rows), 2)):
                buffer_payloads.append(rows[i][1])
        # Update buffer: remove the 2 we just took
        remaining = rows[2:] if len(rows) > 2 else []
        if remaining:
            with open(BUFFER_FILE, mode='w', newline='') as f:
                csv.writer(f).writerows(remaining)
        else:
            os.remove(BUFFER_FILE)

    final_payload = current_payload + last_payload
    for i in range(2):
        final_payload += buffer_payloads[i] if i < len(buffer_payloads) else "0000000000000000"

    last_payload = current_payload
    return final_payload

def send_payload_and_listen(lora_serial, hex_payload):
    """Transmits data and listens for Class A Downlink commands."""
    lora_serial.read_all()
    lora_serial.write(f"AT+SEND=2:{hex_payload}\r\n".encode())

    start_wait = time.time()
    while time.time() - start_wait < 8: # Class A RX1/RX2 window
        if lora_serial.in_waiting > 0:
            response = lora_serial.read_all().decode(errors='ignore').strip()
            if "+EVT:RX" in response:
                print(f"Downlink detected!")
                parts = response.split(':')
                if len(parts) >= 7:
                    handle_downlink(parts[6].strip(), lora_serial)
                return True
        time.sleep(0.1)
    return False

def handle_downlink(hex_cmd, lora_serial):
    """Executes commands received from Network Server."""
    if hex_cmd == "01": # Logic for mass retransmission
        print("ACTION: Server requested buffer dump.")
        if os.path.isfile(BUFFER_FILE):
            with open(BUFFER_FILE, mode='r') as f:
                for _, payload in csv.reader(f):
                    lora_serial.write(f"AT+SEND=2:{payload}\r\n".encode())
                    time.sleep(4)
            os.remove(BUFFER_FILE)
            print("Buffer cleared and sent.")


def main():
    consecutive_failures = 0
    print("DLR Sensor Node Active...")

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
            lora_serial.read_all()
            lora_serial.write(b'AT+NJS=?\r\n')
            time.sleep(1.0)
            if "1" in lora_serial.read_all().decode(errors='ignore'):
                payload = get_combined_payload()
                print(f"Sending: {payload}")
                send_payload_and_listen(lora_serial, payload)
            else:
                print("Connection lost. Re-joining...")
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
