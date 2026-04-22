import serial
import time

# Konfiguration af UART-porten
# Vi bruger serial0, da det automatisk finder den rigtige hardware-port på Pi 3
PORT = '/dev/serial0'
BAUD = 115200
SEND_INTERVAL_SECONDS = 10

def encode_temp_like_master(temp_c):
    """Matcher master.py: temp * 10, cast til int, og 16-bit hex."""
    return f"{(int(temp_c * 10) & 0xFFFF):04X}"

def build_master_like_payload():
    """Bygger en gyldig 24-char payload i samme stil som master.py."""
    timestamp_hex = f"{int(time.time()):08X}"
    temp_fields = (
        encode_temp_like_master(20.0),
        encode_temp_like_master(24.5),
        encode_temp_like_master(58.2),
        encode_temp_like_master(43.7),
    )
    return timestamp_hex + "".join(temp_fields), timestamp_hex, temp_fields

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

        # master.py format: 24 chars total -> 8 timestamp + 4 x 4-char temperaturfelter.
        _, _, valid_temps = build_master_like_payload()

        test_cases = [
            # 1) String payload (ikke i master-format)
            ("String payload", lambda ts: "invalid payload".encode("utf-8").hex()),

            # 2) Edge case 32767 (max for 16-bit signed) i temperaturfelt
            (
                "Edge case 327.67 temperature field",
                lambda ts: f"{ts}{(32767 & 0xFFFF):04X}{valid_temps[1]}{valid_temps[2]}{valid_temps[3]}",
            ),
            # 3) Edge case 32768 (for høj temperatur) i temperaturfelt
            (
                "Over edge case 327.68 temperature field",
                lambda ts: f"{ts}{(32768 & 0xFFFF):04X}{valid_temps[1]}{valid_temps[2]}{valid_temps[3]}",
            ),
            # 4) Edgecase (signed) 16-bit minimum (-32768) i temperaturfelt
            (
                "Edge case -327.68 temperature field",
                lambda ts: f"{ts}{(-32768 & 0xFFFF):04X}{valid_temps[1]}{valid_temps[2]}{valid_temps[3]}",
            ),
            # 5) Edgecase (signed) over 16-bit minimum (-32769) i temperaturfelt
            (
                "Over case -327.69 temperature field",
                lambda ts: f"{ts}{(-32769 & 0xFFFF):04X}{valid_temps[1]}{valid_temps[2]}{valid_temps[3]}",
            ),
        ]

        for index, (label, build_payload) in enumerate(test_cases, start=1):
            timestamp_hex = f"{int(time.time()):08X}"
            payload = build_payload(timestamp_hex)

            print(f"\nTest {index}/{len(test_cases)}: {label}")
            print(f"Payload: {payload} (len={len(payload)} hex chars)")
            send_at(ser, f"AT+SEND=2:{payload}")

            if index < len(test_cases):
                print(
                    f"Venter {SEND_INTERVAL_SECONDS} sekunder...\n---------------------------------"
                )
                time.sleep(SEND_INTERVAL_SECONDS)

        print("\nFærdig med testsekvens.")

    except KeyboardInterrupt:
        print("\nStopper scriptet...")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()

if __name__ == "__main__":
    main()
