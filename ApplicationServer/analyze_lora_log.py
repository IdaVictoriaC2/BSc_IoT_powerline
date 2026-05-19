import re
import math
import argparse
from pathlib import Path
from datetime import datetime

import pandas as pd
import matplotlib.pyplot as plt


MONTHS = {
    "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4,
    "May": 5, "Jun": 6, "Jul": 7, "Aug": 8,
    "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12,
}


def parse_log_timestamp(line: str):
    # Example: Fri May 15 10:56:08 2026
    match = re.match(r"^\w{3}\s+(\w{3})\s+(\d{1,2})\s+(\d{2}:\d{2}:\d{2})\s+(\d{4})", line)
    if not match:
        return None

    month_name, day, clock, year = match.groups()
    month = MONTHS[month_name]
    return datetime.strptime(f"{year}-{month:02d}-{int(day):02d} {clock}", "%Y-%m-%d %H:%M:%S")


def sf_to_estimated_bitrate(sf: int, bw: int, coding_rate: float = 4 / 5):
    # Approximate raw LoRa PHY bit rate.
    return sf * bw / (2 ** sf) * coding_rate


def parse_log(log_text: str):
    frame_rows = []
    stats_rows = []
    duty_rows = []
    downlink_rows = []

    for line in log_text.splitlines():
        ts = parse_log_timestamp(line)
        if not ts:
            continue

        frame_match = re.search(
            r"Frame received, uplink_id: (?P<uplink_id>\d+).*?"
            r"freq: (?P<freq>\d+), bw: (?P<bw>\d+), mod: LoRa, dr: SF(?P<sf>\d+)",
            line
        )

        if frame_match:
            row = frame_match.groupdict()
            sf = int(row["sf"])
            bw = int(row["bw"])
            frame_rows.append({
                "timestamp": ts,
                "uplink_id": int(row["uplink_id"]),
                "frequency_hz": int(row["freq"]),
                "bandwidth_hz": bw,
                "spreading_factor": sf,
                "estimated_bitrate_bps": sf_to_estimated_bitrate(sf, bw),
            })
            continue

        stats_match = re.search(
            r"Publishing stats event, rx_received: (?P<rx_received>\d+), "
            r"rx_received_ok: (?P<rx_received_ok>\d+), "
            r"tx_received: (?P<tx_received>\d+), tx_emitted: (?P<tx_emitted>\d+)",
            line
        )

        if stats_match:
            row = {k: int(v) for k, v in stats_match.groupdict().items()}
            rx_received = row["rx_received"]
            rx_ok = row["rx_received_ok"]
            ok_ratio = rx_ok / rx_received if rx_received else None
            stats_rows.append({
                "timestamp": ts,
                **row,
                "rx_ok_ratio": ok_ratio,
            })
            continue

        duty_match = re.search(
            r"Duty-cyle stats: \[label: (?P<label>\w+).*?dc_max: (?P<dc_max>[\d.]+)%\] - current_dc: (?P<current_dc>[\d.]+)%",
            line
        )

        if duty_match:
            row = duty_match.groupdict()
            duty_rows.append({
                "timestamp": ts,
                "band_label": row["label"],
                "dc_max_percent": float(row["dc_max"]),
                "current_dc_percent": float(row["current_dc"]),
            })
            continue

        downlink_match = re.search(
            r"Scheduled packet for TX, downlink_id: (?P<downlink_id>\d+).*?"
            r"freq: (?P<freq>\d+), bw: (?P<bw>\d+), mod: LoRa, dr: SF(?P<sf>\d+)",
            line
        )

        if downlink_match:
            row = downlink_match.groupdict()
            sf = int(row["sf"])
            bw = int(row["bw"])
            downlink_rows.append({
                "timestamp": ts,
                "downlink_id": int(row["downlink_id"]),
                "frequency_hz": int(row["freq"]),
                "bandwidth_hz": bw,
                "spreading_factor": sf,
                "estimated_bitrate_bps": sf_to_estimated_bitrate(sf, bw),
            })
            continue

    return (
        pd.DataFrame(frame_rows),
        pd.DataFrame(stats_rows),
        pd.DataFrame(duty_rows),
        pd.DataFrame(downlink_rows),
    )


def save_plot(path):
    plt.tight_layout()
    plt.savefig(path, dpi=200)
    plt.close()


def make_plots(frames, stats, duty, downlinks, out_dir):
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    if not frames.empty:
        frames.to_csv(out_dir / "uplink_frames.csv", index=False)

        plt.figure(figsize=(10, 4))
        plt.plot(frames["timestamp"], frames["spreading_factor"], marker="o")
        plt.title("Uplink Spreading Factor Over Time")
        plt.xlabel("Time")
        plt.ylabel("Spreading Factor")
        plt.grid(True)
        save_plot(out_dir / "uplink_spreading_factor_over_time.png")

        plt.figure(figsize=(10, 4))
        plt.plot(frames["timestamp"], frames["estimated_bitrate_bps"], marker="o")
        plt.title("Estimated Uplink Raw LoRa Bit Rate Over Time")
        plt.xlabel("Time")
        plt.ylabel("Estimated bit rate [bit/s]")
        plt.grid(True)
        save_plot(out_dir / "estimated_uplink_bitrate_over_time.png")

        sf_counts = frames["spreading_factor"].value_counts().sort_index()
        plt.figure(figsize=(7, 4))
        plt.bar(sf_counts.index.astype(str), sf_counts.values)
        plt.title("Uplink Spreading Factor Distribution")
        plt.xlabel("Spreading Factor")
        plt.ylabel("Number of uplinks")
        plt.grid(True, axis="y")
        save_plot(out_dir / "uplink_spreading_factor_distribution.png")

        freq_counts = frames["frequency_hz"].value_counts().sort_index()
        plt.figure(figsize=(8, 4))
        plt.bar((freq_counts.index / 1_000_000).astype(str), freq_counts.values)
        plt.title("Uplink Frequency Distribution")
        plt.xlabel("Frequency [MHz]")
        plt.ylabel("Number of uplinks")
        plt.grid(True, axis="y")
        save_plot(out_dir / "uplink_frequency_distribution.png")

        summary = frames.groupby("spreading_factor").agg(
            uplink_count=("uplink_id", "count"),
            avg_estimated_bitrate_bps=("estimated_bitrate_bps", "mean"),
            min_estimated_bitrate_bps=("estimated_bitrate_bps", "min"),
            max_estimated_bitrate_bps=("estimated_bitrate_bps", "max"),
        ).reset_index()
        summary.to_csv(out_dir / "uplink_sf_summary.csv", index=False)

    if not stats.empty:
        stats.to_csv(out_dir / "gateway_stats.csv", index=False)

        plt.figure(figsize=(10, 4))
        plt.plot(stats["timestamp"], stats["rx_received"], marker="o", label="rx_received")
        plt.plot(stats["timestamp"], stats["rx_received_ok"], marker="o", label="rx_received_ok")
        plt.title("Gateway Received Frames Over Time")
        plt.xlabel("Time")
        plt.ylabel("Frames per stats interval")
        plt.legend()
        plt.grid(True)
        save_plot(out_dir / "gateway_rx_stats_over_time.png")

        plt.figure(figsize=(10, 4))
        plt.plot(stats["timestamp"], stats["rx_ok_ratio"], marker="o")
        plt.title("Gateway RX OK Ratio Over Time")
        plt.xlabel("Time")
        plt.ylabel("rx_received_ok / rx_received")
        plt.ylim(0, 1.05)
        plt.grid(True)
        save_plot(out_dir / "gateway_rx_ok_ratio_over_time.png")

    if not duty.empty:
        duty.to_csv(out_dir / "duty_cycle.csv", index=False)

        plt.figure(figsize=(10, 4))
        for label, group in duty.groupby("band_label"):
            plt.plot(group["timestamp"], group["current_dc_percent"], marker="o", label=f"Band {label}")
        plt.title("Gateway Duty Cycle Over Time")
        plt.xlabel("Time")
        plt.ylabel("Current duty cycle [%]")
        plt.legend()
        plt.grid(True)
        save_plot(out_dir / "duty_cycle_over_time.png")

    if not downlinks.empty:
        downlinks.to_csv(out_dir / "downlinks.csv", index=False)

        plt.figure(figsize=(10, 4))
        plt.plot(downlinks["timestamp"], downlinks["spreading_factor"], marker="o")
        plt.title("Downlink Spreading Factor Over Time")
        plt.xlabel("Time")
        plt.ylabel("Spreading Factor")
        plt.grid(True)
        save_plot(out_dir / "downlink_spreading_factor_over_time.png")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("log_file")
    parser.add_argument("--out", default="test-evidence/lora-analysis")
    args = parser.parse_args()

    log_text = Path(args.log_file).read_text(encoding="utf-8", errors="ignore")
    frames, stats, duty, downlinks = parse_log(log_text)

    make_plots(frames, stats, duty, downlinks, args.out)

    print("Parsed:")
    print(f"  uplink frames: {len(frames)}")
    print(f"  gateway stats: {len(stats)}")
    print(f"  duty rows:     {len(duty)}")
    print(f"  downlinks:     {len(downlinks)}")
    print(f"Output written to: {args.out}")

    if not frames.empty:
        print("\nSpreading factor summary:")
        print(frames["spreading_factor"].value_counts().sort_index())


if __name__ == "__main__":
    main()
