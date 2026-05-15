from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import psycopg2

from .config import AppConfig


@dataclass
class Database:
    config: AppConfig

    def connect(self):
        return psycopg2.connect(
            host=self.config.db_host,
            port=self.config.db_port,
            dbname=self.config.db_name,
            user=self.config.db_user,
            password=self.config.db_pass,
        )

    def log_event(
        self,
        event_type: str,
        details: str,
        performed_by: str = "mqtt-listener",
        role: str = "system",
    ) -> None:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        INSERT INTO audit_log (event_type, performed_by, details, description)
                        VALUES (%s, %s, %s, %s);
                        """,
                        (event_type, performed_by, f"Role: {role} | {details}", details),
                    )
        finally:
            conn.close()

    def get_last_measurement(self, dev_eui: str):
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        SELECT device_timestamp, ambient_temp, immediate_temp, conductor_temp, cpu_temp
                        FROM sensor_data
                        WHERE device_eui = %s
                        ORDER BY device_timestamp DESC
                        LIMIT 1;
                        """,
                        (dev_eui,),
                    )
                    return cursor.fetchone()
        finally:
            conn.close()

    def insert_measurement(
        self,
        dev_eui: str,
        device_timestamp,
        ambient_temp: float,
        immediate_temp: float,
        conductor_temp: float,
        cpu_temp: float,
        raw_payload: str,
    ) -> bool:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        INSERT INTO sensor_data
                        (device_eui, device_timestamp, ambient_temp, immediate_temp, conductor_temp, cpu_temp, raw_payload)
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT ON CONSTRAINT unique_measurement DO NOTHING;
                        """,
                        (
                            dev_eui,
                            device_timestamp,
                            ambient_temp,
                            immediate_temp,
                            conductor_temp,
                            cpu_temp,
                            raw_payload,
                        ),
                    )
                    return cursor.rowcount > 0
        finally:
            conn.close()

    def purge_old_data(self, days: int) -> int:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "DELETE FROM sensor_data WHERE device_timestamp < NOW() - (%s || ' days')::interval;",
                        (days,),
                    )
                    return cursor.rowcount
        finally:
            conn.close()

    def get_pending_gaps(self) -> list[dict[str, Any]]:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        SELECT device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count
                        FROM pending_recovery
                        ORDER BY updated_at ASC;
                        """
                    )
                    rows = cursor.fetchall()
                    return [
                        {
                            "device_eui": row[0],
                            "app_id": row[1],
                            "start_ts": row[2],
                            "end_ts": row[3],
                            "last_requested_at": row[4],
                            "retry_count": row[5],
                        }
                        for row in rows
                    ]
        finally:
            conn.close()

    def get_pending_gap_for_update(self, conn, dev_eui: str):
        with conn.cursor() as cursor:
            cursor.execute(
                """
                SELECT device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count
                FROM pending_recovery
                WHERE device_eui = %s
                FOR UPDATE;
                """,
                (dev_eui,),
            )
            row = cursor.fetchone()
            if not row:
                return None
            return {
                "device_eui": row[0],
                "app_id": row[1],
                "start_ts": row[2],
                "end_ts": row[3],
                "last_requested_at": row[4],
                "retry_count": row[5],
            }

    def get_pending_gap(self, dev_eui: str):
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        SELECT device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count
                        FROM pending_recovery
                        WHERE device_eui = %s;
                        """,
                        (dev_eui,),
                    )
                    row = cursor.fetchone()
                    if not row:
                        return None
                    return {
                        "device_eui": row[0],
                        "app_id": row[1],
                        "start_ts": row[2],
                        "end_ts": row[3],
                        "last_requested_at": row[4],
                        "retry_count": row[5],
                    }
        finally:
            conn.close()

    def upsert_pending_gap(
        self,
        dev_eui: str,
        app_id: str,
        start_ts: int,
        end_ts: int,
        last_requested_at: float,
        retry_count: int,
    ) -> None:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        INSERT INTO pending_recovery
                            (device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count, updated_at)
                        VALUES
                            (%s, %s, %s, %s, %s, %s, NOW())
                        ON CONFLICT (device_eui)
                        DO UPDATE SET
                            app_id = EXCLUDED.app_id,
                            start_ts = EXCLUDED.start_ts,
                            end_ts = EXCLUDED.end_ts,
                            last_requested_at = EXCLUDED.last_requested_at,
                            retry_count = EXCLUDED.retry_count,
                            updated_at = NOW();
                        """,
                        (dev_eui, app_id, start_ts, end_ts, last_requested_at, retry_count),
                    )
        finally:
            conn.close()

    def delete_pending_gap(self, dev_eui: str) -> None:
        conn = self.connect()
        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute("DELETE FROM pending_recovery WHERE device_eui = %s;", (dev_eui,))
        finally:
            conn.close()