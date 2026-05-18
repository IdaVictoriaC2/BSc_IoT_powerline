from __future__ import annotations

from dataclasses import dataclass
from os import environ
from typing import Self


@dataclass(frozen=True)
class AppConfig:
    mqtt_broker: str
    mqtt_port: int = 8883
    mqtt_topic: str = "application/+/device/+/event/up"
    mqtt_ca_cert_path: str = ""
    mqtt_client_cert_path: str = ""
    mqtt_client_key_path: str = ""
    db_host: str = ""
    db_port: int = 5432 # fallback, PostgreSQL default
    db_name: str = ""
    db_user: str = ""
    db_pass: str = ""
    temp_limit_max: float = 150.0
    temp_limit_min: float = -40.0
    max_temp_jump_per_minute: float = 5.0
    min_valid_time: int = 1767225600    # 2026-01-01 00:00:00 UTC
    max_future_buffer: int = 60         # 60 seconds
    max_recovery_window_seconds: int = 86400    # 24 hours
    max_gap: int = 75
    recovery_retry_after_seconds: int = 3600    # 1 hour
    max_recovery_retries: int = 3
    pending_gap_check_interval: int = 60
    gap_fill_tolerance_seconds: int = 45
    mqtt_client_id: str = "scada_mqtt_listener_docker_v1"

    @classmethod
    def from_env(cls, strict: bool = True) -> Self:
        """Build configuration from environment variables.

        If strict is False, missing values are allowed so the package can be
        used for dry-run checks before the deployment wiring is complete.
        """

        required_env = {
            "MQTT_BROKER": environ.get("MQTT_BROKER", ""),
            "MQTT_CA_CERT_PATH": environ.get("MQTT_CA_CERT_PATH", ""),
            "DB_HOST": environ.get("DB_HOST", ""),
            "DB_NAME": environ.get("DB_NAME", ""),
            "DB_USER": environ.get("DB_USER", ""),
            "DB_PASS": environ.get("DB_PASS", ""),
        }

        if strict:
            missing = [name for name, value in required_env.items() if not value]
            if missing:
                raise ValueError(
                    "Missing required environment variables: " + ", ".join(sorted(missing))
                )

        return cls(
            mqtt_broker=required_env["MQTT_BROKER"],
            mqtt_port=int(environ.get("MQTT_PORT", "8883")),
            mqtt_topic=environ.get("MQTT_TOPIC", "application/+/device/+/event/up"),
            mqtt_ca_cert_path=required_env["MQTT_CA_CERT_PATH"],
            mqtt_client_cert_path=os.environ.get("MQTT_CLIENT_CERT_PATH", ""),
            mqtt_client_key_path=os.environ.get("MQTT_CLIENT_KEY_PATH", ""),
            db_host=required_env["DB_HOST"],
            db_port=int(environ.get("DB_PORT", "5432")),
            db_name=required_env["DB_NAME"],
            db_user=required_env["DB_USER"],
            db_pass=required_env["DB_PASS"],
            temp_limit_max=float(environ.get("TEMP_LIMIT_MAX", "150")),
            temp_limit_min=float(environ.get("TEMP_LIMIT_MIN", "-40")),
            max_temp_jump_per_minute=float(environ.get("MAX_TEMP_JUMP_PER_MINUTE", "5.0")),
            min_valid_time=int(environ.get("MIN_VALID_TIME", "1767225600")),
            max_future_buffer=int(environ.get("MAX_FUTURE_BUFFER", "60")),
            max_recovery_window_seconds=int(environ.get("MAX_RECOVERY_WINDOW_SECONDS", "86400")),
            max_gap=int(environ.get("MAX_GAP", "75")),
            recovery_retry_after_seconds=int(environ.get("RECOVERY_RETRY_AFTER_SECONDS", "3600")),
            max_recovery_retries=int(environ.get("MAX_RECOVERY_RETRIES", "3")),
            pending_gap_check_interval=int(environ.get("PENDING_GAP_CHECK_INTERVAL", "60")),
            gap_fill_tolerance_seconds=int(environ.get("GAP_FILL_TOLERANCE_SECONDS", "45")),
            mqtt_client_id=environ.get("MQTT_CLIENT_ID", "scada_mqtt_listener_docker_v1"),
        )

    def validate(self) -> list[str]:
        """Return a list of missing required values."""

        missing: list[str] = []
        if not self.mqtt_broker:
            missing.append("MQTT_BROKER")
        if not self.mqtt_ca_cert_path:
            missing.append("MQTT_CA_CERT_PATH")
        if not self.db_host:
            missing.append("DB_HOST")
        if not self.db_name:
            missing.append("DB_NAME")
        if not self.db_user:
            missing.append("DB_USER")
        if not self.db_pass:
            missing.append("DB_PASS")
        return missing



def load_config(strict: bool = True) -> AppConfig:
    return AppConfig.from_env(strict=strict)
