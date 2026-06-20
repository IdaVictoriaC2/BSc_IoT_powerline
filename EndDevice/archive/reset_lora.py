import serial
import time

# Konfiguration
SERIAL_PORT = '/dev/serial0'
BAUD_RATE = 115200

ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=2)

def send_at(cmd):
    print(f"Sender: {cmd}")
    ser.write((cmd + '\r\n').encode())
    time.sleep(2)
    if ser.in_waiting > 0:
        print(f"Svar: {ser.read_all().decode(errors='ignore').strip()}")

print("--- NULSTILLER LORA MODUL ---")
send_at('AT+FACNEW')    # Fabriksindstillinger
send_at('AT+BAND=4')    # Sæt til EU868
send_at('AT+NWM=1')     # Sæt til LoRaWAN mode
send_at('AT+JOIN=0:0:10:8') # Stop evt. kørende join
send_at('AT+SAVE')      # Gem indstillinger
print("--- FÆRDIG ---")
ser.close()
