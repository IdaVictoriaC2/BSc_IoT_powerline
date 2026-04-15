import serial
import time
from gpiozero import OutputDevice
from rakReset import rak_reset

SERIAL_PORT = '/dev/serial0'
BAUD_RATE = 115200
AT_TIMEOUT = 2 # seconds
MAX_FAILURES = 3

def is_lora_alive(lora_serial):
    """ Sends 'AT' and return True if 'OK' is received, False otherwise. """

    lora_serial.reset_input_buffer() # Clear any existing data
    lora_serial.write(b'AT\r\n') # Send AT command

    start_time = time.time() # Start timer
    response = b''

    while time.time() - start_time < AT_TIMEOUT:
        if lora_serial.in_waiting > 0:
            response += lora_serial.read(lora_serial.in_waiting) # Read available data

            if b'OK' in response:
                return True # LoRa is alive
        time.sleep(0.1) # Small delay to avoid busy waiting

    try:
        decoded_response = response.decode('utf-8').strip()
    except:
        decoded_response = response.hex() # Fallback to hex if decoding fails

    print(f"Received no 'OK' response within timeout. Received: {decoded_response}")
    return False # LoRa is not alive

def lora_join_otaa(lora_serial):
    """ Attempts to join the LoRa network using OTAA. """
    print("Attempting to join LoRa network using OTAA...")
    lora_serial.reset_input_buffer() # Clear any existing data
    lora_serial.write(b'AT+JOIN\r\n') # Send join command

    join_timeout = 15 # seconds
    start_time = time.time()
    response = b''
    while time.time() - start_time < join_timeout:
        if lora_serial.in_waiting > 0:
            response += lora_serial.read(lora_serial.in_waiting) # Read available data

            if b'JOINED' in response or b'accepted' in response or b'+JOIN: Done' in response:
                print("OTAA join successful!")
                return True

        time.sleep(0.5) # Small delay to avoid busy waiting
    print("OTAA join attempt timed out. Received: " + response.decode('utf-8', errors='ignore').strip())
    return False


def main():
    consecutive_failures = 0
    print("Starting LoRa Watchdog...")

    try:
        lora_serial = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=AT_TIMEOUT)
    except Exception as e:
        print(f"Failed to open serial port {SERIAL_PORT}: {e}")
        return

    rak_reset()

    while True:
        if is_lora_alive(lora_serial):
            # Success!
            if consecutive_failures > 0:
                print(" Watchdog: LoRa is alive again.")
            consecutive_failures = 0
        else:
            # Failure!
            consecutive_failures += 1
            print(f" Watchdog: LoRa is not responding! Failure count: {consecutive_failures}")
            if consecutive_failures >= MAX_FAILURES:
                rak_reset()
                consecutive_failures = 0 # Reset failure count after hard reset
                lora_join_otaa()
        time.sleep(10) # Check every 10 seconds

if __name__ == "__main__":
    main()
