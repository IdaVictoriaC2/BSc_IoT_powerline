import serial
import time
import random
import RPi.GPIO as GPIO

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

def reset_rak_module():
    """Forces a hardware restart of the RAK module via the GPIO pin."""
    print("\n--- PERFORMING HARDWARE RESET ---")
    GPIO.output(RST_PIN, GPIO.LOW)
    time.sleep(3)   # Hold RST low for 3 seconds
    GPIO.output(RST_PIN, GPIO.HIGH)
    time.sleep(2)   # Allow the module 2 seconds to boot up
    print("--- RESET COMPLETE ---\n")

def is_lora_alive(lora_serial):
    """Sends 'AT' and returns True if 'OK' is received."""
    lora_serial.reset_input_buffer()
    lora_serial.write(b'AT\r\n')

    start_time = time.time()
    response = b''

    while time.time() - start_time < AT_TIMEOUT:
        if lora_serial.in_waiting > 0:
            response += lora_serial.read(lora_serial.in_waiting)
            if b'OK' in response:
                return True
        time.sleep(0.1)

    try:
        decoded_response = response.decode('utf-8').strip()
    except:
        decoded_response = response.hex()

    print(f"Watchdog: No 'OK' received. Got: {decoded_response}")
    return False

def lora_join_otaa(lora_serial):
    """Requests to join the LoRaWAN network using OTAA."""
    print("Attempting to join LoRa network (OTAA)...")
    lora_serial.reset_input_buffer()
    lora_serial.write(b'AT+JOIN=1:1:10:8\r\n')

    join_timeout = 15.0 # Seconds to wait for Join Accept from the Network Server
    start_time = time.time()
    response = b''

    while time.time() - start_time < join_timeout:
        if lora_serial.in_waiting > 0:
            response += lora_serial.read(lora_serial.in_waiting)
            if b'JOINED' in response or b'accepted' in response or b'+JOIN: Done' in response:
                print("OTAA join successful!")
                return True
        time.sleep(0.5)

    print(f"OTAA join timeout. Got: {response.decode('utf-8', errors='ignore').strip()}")
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

def send_sensor_data(lora_serial):
    """Generates simulated telemetry data and transmits it."""
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

    lora_serial.reset_input_buffer()
    lora_serial.write(f"AT+SEND=2:{payload}\r\n".encode())
    time.sleep(2)
    if lora_serial.in_waiting > 0:
         print(f"LoRa answer: {lora_serial.read_all().decode(errors='ignore').strip()}")

def main():
    consecutive_failures = 0

    print("Starting Autonomous Sensor Firmware...")

    try:
        lora_serial = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=AT_TIMEOUT)
    except Exception as e:
        print(f"Error: Could not open serial port {SERIAL_PORT}: {e}")
        return

    # 1. Cold boot requirement (FR4): Always reset the hardware on startup
    reset_rak_module()

    # 2. Join the network (FR6)
    lora_join_otaa(lora_serial)

    # 3. Main system loop
    while True:
        # CHECK 1: Is the module awake and responsive?
        if is_lora_alive(lora_serial):
            consecutive_failures = 0 # Reset the failure counter

            # CHECK 2: If alive, generate and send the sensor data
            send_sensor_data(lora_serial)

            # CHECK 3: Wait for the next transmission window to respect Duty Cycle constraints
            print(f"Waiting {SEND_INTERVAL} seconds...\n---------------------------")
            time.sleep(SEND_INTERVAL)

        else:
            # Error handling: The module is unresponsive!
            consecutive_failures += 1
            print(f"Watchdog: Failure count = {consecutive_failures}")

            if consecutive_failures >= MAX_FAILURES:
                print("Watchdog limit reached! Forcing hardware reset...")
                reset_rak_module()
                lora_join_otaa(lora_serial)
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
