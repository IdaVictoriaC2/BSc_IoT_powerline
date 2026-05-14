from __future__ import annotations

import argparse
from typing import Sequence

from .config import load_config
from .listener import MqttListener


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="ApplicationServer MQTT listener.")
    parser.add_argument(
        "--check-config",
        action="store_true",
        help="Validate required environment variables and exit without starting MQTT.",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(list(argv) if argv is not None else None)

    if args.check_config:
        config = load_config(strict=False)
        missing = config.validate()
        if missing:
            print("Configuration check failed. Missing:")
            for name in missing:
                print(f"- {name}")
            return 1

        print("Configuration looks complete.")
        print(f"Broker: {config.mqtt_broker}:{config.mqtt_port}")
        print(f"Topic: {config.mqtt_topic}")
        print(f"Database: {config.db_user}@{config.db_host}:{config.db_port}/{config.db_name}")
        return 0

    config = load_config(strict=True)
    listener = MqttListener(config)
    listener.run()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
