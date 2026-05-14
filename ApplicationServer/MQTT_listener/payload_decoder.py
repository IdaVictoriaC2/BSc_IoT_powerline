from __future__ import annotations

import base64
import datetime as dt
import struct
from dataclasses import dataclass


@dataclass(frozen=True)
class Measurement:
    device_timestamp: dt.datetime
    ambient_temp: float
    immediate_temp: float
    conductor_temp: float
    cpu_temp: float
    raw_payload_hex: str



def decode_payload(base64_data: str) -> tuple[list[Measurement], str]:
    """Decode base64 payload into measurement rows.

    The function stays pure so it can be unit-tested independently of MQTT and
    PostgreSQL. It preserves a 12-byte block format
    """

    try:
        raw_bytes = base64.b64decode(base64_data)
    except Exception:
        print("Error: Failed to decode base64 payload.")
        return [], ""

    if len(raw_bytes) % 12 != 0:
        print(f"Warning: Received malformed payload of {len(raw_bytes)} bytes. Skipping.")
        return [], raw_bytes.hex()

    measurements: list[Measurement] = []
    for index in range(0, len(raw_bytes), 12):
        block = raw_bytes[index : index + 12]
        if len(block) != 12 or block == b"\x00" * 12:
            continue

        timestamp, ambient, immediate, conductor, cpu = struct.unpack(">Lhhhh", block)
        device_timestamp = dt.datetime.fromtimestamp(timestamp, dt.timezone.utc)
        measurements.append(
            Measurement(
                device_timestamp=device_timestamp,
                ambient_temp=round(ambient / 100.0, 2),
                immediate_temp=round(immediate / 100.0, 2),
                conductor_temp=round(conductor / 100.0, 2),
                cpu_temp=round(cpu / 100.0, 2),
                raw_payload_hex=block.hex(),
            )
        )

    measurements.sort(key=lambda row: row.device_timestamp)
    return measurements, raw_bytes.hex()
