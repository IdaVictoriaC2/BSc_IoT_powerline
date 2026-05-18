from __future__ import annotations

import base64
import datetime as dt
import json
import struct
import threading
import time
from dataclasses import dataclass, field
from zoneinfo import ZoneInfo

from .config import AppConfig
from .db import Database


@dataclass
class GapRecoveryService:
    config: AppConfig
    database: Database
    pending_gaps_lock: threading.Lock = field(default_factory=threading.Lock)

    def _fetch_timestamps(self, cursor, dev_eui: str, start_ts: int, end_ts: int) -> list[int]:
        cursor.execute(
            """
            SELECT EXTRACT(EPOCH FROM device_timestamp)::bigint
            FROM sensor_data
            WHERE device_eui = %s
              AND device_timestamp >= to_timestamp(%s)
              AND device_timestamp <= to_timestamp(%s)
            ORDER BY device_timestamp ASC;
            """,
            (dev_eui, start_ts, end_ts),
        )
        return [row[0] for row in cursor.fetchall()]

    def check_for_missing_data(self, client, dev_eui: str, app_id: str | None, current_device_ts: dt.datetime) -> None:
        last_record = self.database.get_last_measurement(dev_eui)
        if not last_record:
            return

        last_ts = last_record[0]
        if last_ts.tzinfo is None:
            last_ts = last_ts.replace(tzinfo=dt.timezone.utc)
        if current_device_ts.tzinfo is None:
            current_device_ts = current_device_ts.replace(tzinfo=dt.timezone.utc)

        gap = current_device_ts.timestamp() - last_ts.timestamp()
        if gap <= self.config.max_gap:
            return

        start_ts = int(last_ts.timestamp()) + 1
        end_ts = int(current_device_ts.timestamp()) - 1

        if gap > self.config.max_recovery_window_seconds:
            start_ts = int(current_device_ts.timestamp()) - self.config.max_recovery_window_seconds
            print(
                f"Large gap detected for {dev_eui}: {int(gap)}s. "
                f"Limiting recovery request to the last 24 hours."
            )
        request_to_send = None
        with self.pending_gaps_lock:
            existing_gap = self.database.get_pending_gap(dev_eui)
            conn = self.database.connect()
            try:
                if existing_gap:
                    new_start = min(existing_gap["start_ts"], start_ts)
                    new_end = max(existing_gap["end_ts"], end_ts)
                    if new_end - new_start > self.config.max_recovery_window_seconds:
                        new_start = new_end - self.config.max_recovery_window_seconds
                        print(
                            f"Recovery interval for {dev_eui} exceeded 24h. "
                            f"Trimming start to {new_start}."
                        )
                    self.database.upsert_pending_gap(
                        conn=conn,
                        dev_eui=dev_eui,
                        app_id=app_id or "",
                        start_ts=new_start,
                        end_ts=new_end,
                        last_requested_at=time.time(),
                        retry_count=0,
                    )
                    request_to_send = (app_id, dev_eui, new_start, new_end)
                else:
                    self.database.upsert_pending_gap(
                        conn=conn,
                        dev_eui=dev_eui,
                        app_id=app_id or "",
                        start_ts=start_ts,
                        end_ts=end_ts,
                        last_requested_at=time.time(),
                        retry_count=0,
                    )
                    print(f"!!! GAP DETECTED: {int(gap)}s gap for {dev_eui}. Requesting specific range.")
                    request_to_send = (app_id, dev_eui, start_ts, end_ts)
            finally:
                conn.close()

        if request_to_send:
            self.send_retransmission_request(client, *request_to_send)

    def check_pending_gaps_after_insert(self, client) -> None:
        for gap in self.database.get_pending_gaps():
            conn = self.database.connect()
            try:
                with conn:
                    locked_gap = self.database.get_pending_gap_for_update(conn, gap["device_eui"])
                    if not locked_gap:
                        continue

                    if self.is_gap_filled(conn, locked_gap["device_eui"], locked_gap["start_ts"], locked_gap["end_ts"]):
                        self.database.log_event(
                            "RECOVERY_COMPLETED",
                            f"Recovery interval {locked_gap['start_ts']}-{locked_gap['end_ts']} completed for {locked_gap['device_eui']}.",
                        )
                        self.database.delete_pending_gap(conn, locked_gap["device_eui"])
            finally:
                conn.close()


    def is_gap_filled(self, conn, dev_eui: str, start_ts: int, end_ts: int) -> bool:
        with conn.cursor() as cursor:
            timestamps = self._fetch_timestamps(cursor, dev_eui, start_ts, end_ts)

        if not timestamps:
            print(
                f"Recovery check for {dev_eui}: no data in requested interval "
                f"{start_ts}-{end_ts}"
            )
            return False

        if timestamps[0] - start_ts > self.config.gap_fill_tolerance_seconds:
            print(
                f"Recovery not complete: missing beginning of interval "
                f"({timestamps[0] - start_ts}s after requested start)."
            )
            return False
        if end_ts - timestamps[-1] > self.config.gap_fill_tolerance_seconds:
            print(
                f"Recovery not complete: missing end of interval "
                f"({end_ts - timestamps[-1]}s before requested end)."
            )
            return False
        for prev_ts, next_ts in zip(timestamps, timestamps[1:]):
            if next_ts - prev_ts > self.config.gap_fill_tolerance_seconds:
                print(
                    f"Recovery not complete: internal gap detected "
                    f"from {prev_ts} to {next_ts} ({next_ts - prev_ts}s)."
                )
                return False
        return True

    def send_retransmission_request(self, client, app_id: str | None, dev_eui: str, start_ts: int, end_ts: int) -> None:
        if not app_id:
            self.database.log_event(
                "RECOVERY_REQUEST_FAILED",
                f"Cannot request retransmission for {dev_eui}: applicationId missing.",
            )
            return

        downlink_topic = f"application/{app_id}/device/{dev_eui}/command/down"
        binary_payload = struct.pack(">BII", 2, start_ts, end_ts)
        b64_payload = base64.b64encode(binary_payload).decode("utf-8")
        client.publish(
            downlink_topic,
            json.dumps({
                "devEui": dev_eui,
                "confirmed": False,
                "fPort": 2,
                "data": b64_payload,
            }),
        )

        dk_tz = ZoneInfo("Europe/Copenhagen")
        start_dt = dt.datetime.fromtimestamp(start_ts, dt.timezone.utc).astimezone(dk_tz)
        end_dt = dt.datetime.fromtimestamp(end_ts, dt.timezone.utc).astimezone(dk_tz)
        self.database.log_event(
            "RECOVERY_REQUEST",
            f"Requested retransmission from {dev_eui}: {start_ts} to {end_ts}, Base64: {b64_payload}",
        )
        print(
            f"Retransmit sent for {dev_eui}: {start_dt:%Y-%m-%d %H:%M:%S %Z} to {end_dt:%Y-%m-%d %H:%M:%S %Z}"
            f"(Unix: {start_ts} to {end_ts}, Base64: {b64_payload})"
        )

    def recovery_retry_loop(self, client) -> None:
        while True:
            time.sleep(self.config.pending_gap_check_interval)
            now = time.time()
            for gap in self.database.get_pending_gaps():
                request_args = None
                conn = self.database.connect()
                try:
                    with conn:
                        locked_gap = self.database.get_pending_gap_for_update(conn, gap["device_eui"])
                        if not locked_gap:
                            continue

                        if self.is_gap_filled(conn, locked_gap["device_eui"], locked_gap["start_ts"], locked_gap["end_ts"]):
                            self.database.log_event(
                                "RECOVERY_COMPLETED",
                                f"Recovery interval {locked_gap['start_ts']}-{locked_gap['end_ts']} completed for {locked_gap['device_eui']}.",
                            )
                            self.database.delete_pending_gap(conn, locked_gap["device_eui"])
                            continue

                        if now - float(locked_gap.get("last_requested_at", 0)) < self.config.recovery_retry_after_seconds:
                            continue

                        retry_count = int(locked_gap.get("retry_count", 0))
                        if retry_count >= self.config.max_recovery_retries:
                            self.database.log_event(
                                "RECOVERY_FAILED",
                                f"Recovery failed for {locked_gap['device_eui']}: interval {locked_gap['start_ts']}-{locked_gap['end_ts']} was not filled after {self.config.max_recovery_retries} retries.",
                            )
                            self.database.delete_pending_gap(conn, locked_gap["device_eui"])
                            continue

                        self.database.upsert_pending_gap(
                            conn = conn,
                            dev_eui=locked_gap["device_eui"],
                            app_id=locked_gap["app_id"],
                            start_ts=locked_gap["start_ts"],
                            end_ts=locked_gap["end_ts"],
                            last_requested_at=now,
                            retry_count=retry_count + 1,
                        )
                        request_args = (
                            locked_gap["app_id"],
                            locked_gap["device_eui"],
                            locked_gap["start_ts"],
                            locked_gap["end_ts"],
                        )
                finally:
                    conn.close()

                if request_args:
                    self.send_retransmission_request(client, *request_args)