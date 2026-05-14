from __future__ import annotations

import datetime as dt
from dataclasses import dataclass, field

from .config import AppConfig
from .db import Database


@dataclass
class RetentionService:
    config: AppConfig
    database: Database
    last_cleanup_date: dt.date | None = field(default=None)

    def run_once_per_day(self) -> int | None:
        current_date = dt.date.today()
        if self.last_cleanup_date == current_date:
            return None

        deleted_rows = self.database.purge_old_data(30)
        self.database.log_event(
            "SYSTEM_PURGE",
            f"Automated cleanup deleted {deleted_rows} records.",
        )
        self.last_cleanup_date = current_date
        return deleted_rows