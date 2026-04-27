import serial
import time

# Konfiguration af UART-porten
# Vi bruger serial0, da det automatisk finder den rigtige hardware-port på Pi 3
PORT = '/dev/serial0'
BAUD = 115200
SEND_INTERVAL_SECONDS = 10

def encode_temp_like_master(temp_c):
    """Matcher master.py: temp * 100, cast til int, og 16-bit hex."""
    return f"{(int(temp_c * 100) & 0xFFFF):04X}"

def build_payload_with_timestamp(timestamp_value):
    """Bygger en 24-char payload med specifik timestamp."""
    timestamp_hex = f"{timestamp_value:08X}"
    # Use fixed temperature values for consistency
    temp_fields = (
        encode_temp_like_master(20.0),
        encode_temp_like_master(24.5),
        encode_temp_like_master(58.2),
        encode_temp_like_master(43.7),
    )
    return timestamp_hex + "".join(temp_fields)

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

        # Get a base timestamp and create out-of-order timestamps
        base_time = int(time.time())

        test_cases = [
            # 1) Normal payload with current timestamp
            (
                "Normal payload (T0)",
                lambda: build_payload_with_timestamp(base_time),
            ),

            # 2) Out-of-order: send an older timestamp (30 seconds in the past)
            (
                "Out-of-order (T0 - 30 sec)",
                lambda: build_payload_with_timestamp(base_time - 30),
            ),

            # 3) Out-of-order: send an even older timestamp (60 seconds in the past)
            (
                "Out-of-order (T0 - 60 sec)",
                lambda: build_payload_with_timestamp(base_time - 60),
            ),

            # 4) Out-of-order: send a newer timestamp (but not sequential)
            (
                "Out-of-order (T0 + 30 sec)",
                lambda: build_payload_with_timestamp(base_time + 30),
            ),

            # 5) Malformed payload: wrong timestamp format (DDMMYYYY instead of Unix timestamp)
            (
                "Malformed: DDMMYYYY timestamp format instead of Unix",
                lambda: f"{int(time.strftime('%d%m%Y')):08X}{encode_temp_like_master(20.0)}{encode_temp_like_master(24.5)}{encode_temp_like_master(58.2)}{encode_temp_like_master(43.7)}",
            ),
        ]

        for index, (label, build_payload) in enumerate(test_cases, start=1):
            payload = build_payload()

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
