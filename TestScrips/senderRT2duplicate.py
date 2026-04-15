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

def get_pi_cpu_temp():
    """ Read the physical CPU-temperature of the Raspberry Pi's chip"""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            # Value is in milli-degress (fx 45000 = 45.0 degress)
            return float(f.read().strip()) / 1000.0
    except:
        return 40.0 # Standard fallback

def payload_hex():
    """Generates 12-byte payload: 4-byte timestamp + 8-byte sensor payload."""
    timestamp = int(time.time())
    ts_hex = f"{timestamp:08X}"

    cpu_temp = get_pi_cpu_temp()
    amb = cpu_temp - 25.0
    imm = amb + random.uniform(2.0, 5.0)
    con = imm + random.uniform(30.0, 50.0)

    t_amb, t_imm, t_con, t_cpu = int(amb*10), int(imm*10), int(con*10), int(cpu_temp*10)
    sensor_hex = f"{(t_amb & 0xFFFF):04X}{(t_imm & 0xFFFF):04X}{(t_con & 0xFFFF):04X}{(t_cpu & 0xFFFF):04X}"
    return ts_hex + sensor_hex

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
            # --- GENERER DUPLICATE PAYLOAD ---
            payload = duplicate_payload_hex()
            duplicate = payload + payload

            print(f"\nSender duplicate payload")

            # 3. Send data via LoRaWAN (Port 2)
            send_at(ser, f"AT+SEND=2:{duplicate}")

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
