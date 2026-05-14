from __future__ import annotations

import datetime as dt
import json
import threading
import time
from dataclasses import dataclass, field

import paho.mqtt.client as mqtt

from .config import AppConfig
from .db import Database
from .payload_decoder import decode_payload
from .recovery_service import GapRecoveryService
from .retention_service import RetentionService


@dataclass
class MqttListener:
    config: AppConfig
    database: Database = field(init=False)
    retention_service: RetentionService = field(init=False)
    recovery_service: GapRecoveryService = field(init=False)
    client: mqtt.Client = field(init=False)

    def __post_init__(self) -> None:
        self.database = Database(self.config)
        self.retention_service = RetentionService(self.config, self.database)
        self.recovery_service = GapRecoveryService(self.config, self.database)
        self.client = mqtt.Client(
            callback_api_version=mqtt.CallbackAPIVersion.VERSION2,
            client_id=self.config.mqtt_client_id,
        )
        self.client.tls_set(ca_certs=self.config.mqtt_ca_cert_path)
        self.client.tls_insecure_set(False)
        self.client.on_connect = self.on_connect
        self.client.on_disconnect = self.on_disconnect
        self.client.on_message = self.on_message

    def on_connect(self, client, userdata, flags, reason_code, properties):
        print(
            f"Connected to MQTT with reason code {reason_code}, listening at {self.config.mqtt_topic}",
            flush=True,
        )
        client.subscribe(self.config.mqtt_topic, qos=1)

    def on_disconnect(self, client, userdata, disconnect_flags, reason_code, properties):
        print(f"Disconnected from MQTT. Reason: {reason_code}", flush=True)

    def _auto_purge_old_data(self) -> None:
        deleted_rows = self.retention_service.run_once_per_day()
        if deleted_rows is not None:
            print(f"Cleanup complete. Deleted {deleted_rows} rows.")

    def _validate_measurement(self, dev_eui: str, dt_value: dt.datetime, amb: float, imm: float, con: float, cpu: float) -> bool:
        ts_unix = dt_value.timestamp()
        current_time = time.time()

        if ts_unix < self.config.min_valid_time:
            self.database.log_event("TIME_ANOMALY", f"Rejected: Timestamp is in the past (Epoch error: {dt_value})")
            return False
        if ts_unix > current_time + self.config.max_future_buffer:
            self.database.log_event("TIME_ANOMALY", f"Rejected: Future timestamp ({dt_value}). Server time is {dt.datetime.now()}")
            return False

        all_temps = [amb, imm, con, cpu]
        if any(temp < self.config.temp_limit_min or temp > self.config.temp_limit_max for temp in all_temps):
            self.database.log_event(
                "SANITY_REJECTION",
                f"Rejected record from {dev_eui}: Out of bounds detected. Values: Amb:{amb}, Imm:{imm}, Con:{con}, CPU:{cpu}",
            )
            return False

        return True

    def on_message(self, client, userdata, msg):
        self._auto_purge_old_data()
        print("\n--- New DLR Telemetry Received ---")

        try:
            payload_json = json.loads(msg.payload.decode("utf-8"))
            dev_eui = payload_json.get("deviceInfo", {}).get("devEui", "UNKNOWN")
            app_id = payload_json.get("deviceInfo", {}).get("applicationId")
            base64_data = payload_json.get("data", "")

            if not base64_data:
                return

            measurements, raw_payload_hex = decode_payload(base64_data)
            if not measurements:
                msg = (
                    f"No valid measurements decoded from {dev_eui}. "
                    f"Raw payload hex: {raw_payload_hex if raw_payload_hex else 'unavailable'}"
                )
                print(msg)
                self.database.log_event("MALFORMED_PAYLOAD", msg)
                return

            self.recovery_service.check_for_missing_data(client, dev_eui, app_id, measurements[-1].device_timestamp)

            saved_count = 0
            last_vals = self.database.get_last_measurement(dev_eui)

            for measurement in measurements:
                if not self._validate_measurement(
                    dev_eui,
                    measurement.device_timestamp,
                    measurement.ambient_temp,
                    measurement.immediate_temp,
                    measurement.conductor_temp,
                    measurement.cpu_temp,
                ):
                    continue

                if last_vals and measurement.device_timestamp.timestamp() > last_vals[0].timestamp():
                    last_ts = last_vals[0].timestamp()
                    last_amb = float(last_vals[1])
                    time_delta = (measurement.device_timestamp.timestamp() - last_ts) / 60
                    jump = abs(measurement.ambient_temp - last_amb)
                    effective_min = max(time_delta, 1.0)
                    allowed_jump = effective_min * self.config.max_temp_jump_per_minute
                    if jump > min(allowed_jump, 80.0):
                        self.database.log_event(
                            "JUMP_ANOMALY",
                            f"Rejected record from {dev_eui}: Sudden jump detected! Changed {jump}°C over {round(time_delta, 2)} min.",
                        )
                        continue

                saved = self.database.insert_measurement(
                    dev_eui=dev_eui,
                    device_timestamp=measurement.device_timestamp,
                    ambient_temp=measurement.ambient_temp,
                    immediate_temp=measurement.immediate_temp,
                    conductor_temp=measurement.conductor_temp,
                    cpu_temp=measurement.cpu_temp,
                    raw_payload=measurement.raw_payload_hex,
                )
                if saved:
                    saved_count += 1
                    last_vals = (
                        measurement.device_timestamp,
                        measurement.ambient_temp,
                        measurement.immediate_temp,
                        measurement.conductor_temp,
                        measurement.cpu_temp,
                    )

            if saved_count > 0:
                print("Data successfully saved to database.")
                self.recovery_service.check_pending_gaps_after_insert(client)
            else:
                print("No new measurements were saved (due to errors or duplicates)")

        except Exception as exc:
            print(f"Error processing message: {exc}")

    def run(self) -> None:
        print("Starting Application Server MQTT Listener...")
        self.client.connect(self.config.mqtt_broker, self.config.mqtt_port, 60)

        retry_thread = threading.Thread(
            target=self.recovery_service.recovery_retry_loop,
            args=(self.client,),
            daemon=True,
        )
        retry_thread.start()

        self.client.loop_forever()