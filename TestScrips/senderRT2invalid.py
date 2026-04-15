import serial
import time
import random

# Konfiguration af UART-porten
# Vi bruger serial0, da det automatisk finder den rigtige hardware-port på Pi 3
PORT = '/dev/serial0'
BAUD = 115200

def send_at(ser, command):
    """Sender en AT-kommando og returnerer svaret"""
    full_command = command + "\r\n"
    ser.write(full_command.encode())
    time.sleep(2)  # Vent på at modulet processerer
    if ser.in_waiting:
        response = ser.read_all().decode(errors='ignore').strip()
        print(f"> {command}\n< {response}")
        return response
    return ""

def main():
    try:
        # Åbn seriel forbindelse
        ser = serial.Serial(PORT, BAUD, timeout=1)
        print(f"Forbundet til RAK3172 på {PORT}")

        # 1. Tjek om modulet er klar
        send_at(ser, "AT")

        # 2. Tjek om vi er joinet (valgfrit, men godt for stabilitet)
        # Slet # foran næste linje, hvis modulet skal joine netværket først:
        # send_at(ser, "AT+JOIN=1:0:10:8")

        while True:
            # --- SEND INVALID PAYLOAD ---
            # Lav til HEX-string (2 bytes for hver for at være sikker)
            # f.feks. 225 bliver '00E1', 45 bliver '002D'
            string = "invalid payload"
            payload = string.encode("utf-8").hex()

            print(f"\nSender et invalid payload")

            # 3. Send data via LoRaWAN (Port 2)
            send_at(ser, f"AT+SEND=2:{payload}")

            # Vent 30 sekunder før næste måling (Husk Duty Cycle regler!)
            print("Venter 30 sekunder...\n---------------------------------")
            time.sleep(30)

    except KeyboardInterrupt:
        print("\nStopper scriptet...")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()

if __name__ == "__main__":
    main()
