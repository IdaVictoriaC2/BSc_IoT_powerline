import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path


DB_CONFIG = {
    "host": os.environ.get("DB_HOST", "localhost"),
    "port": os.environ.get("DB_PORT", "5433"),
    "dbname": os.environ.get("DB_NAME", "powerline_telemetry"),
    "user": os.environ.get("DB_USER", "app_user"),
    "password": os.environ["DB_PASS"],
}


def estimated_lora_bitrate(sf, bw, coding_rate=4 / 5):
    if sf is None or bw is None:
        return None
    return sf * bw / (2 ** sf) * coding_rate


def load_metadata():
    query = """
        SELECT
            received_at,
            device_eui,
            gateway_id,
            frequency_hz,
            bandwidth_hz,
            spreading_factor,
            rssi_dbm,
            snr_db,
            f_cnt
        FROM lora_uplink_metadata
        WHERE spreading_factor IS NOT NULL
        ORDER BY received_at ASC;
    """

    conn = psycopg2.connect(**DB_CONFIG)
    df = pd.read_sql_query(query, conn)
    conn.close()

    if df.empty:
        return df

    df["estimated_bitrate_bps"] = df.apply(
        lambda row: estimated_lora_bitrate(row["spreading_factor"], row["bandwidth_hz"]),
        axis=1,
    )

    return df


def save_plot(path):
    plt.tight_layout()
    plt.savefig(path, dpi=200)
    plt.close()


def main():
    out_dir = Path("test-evidence/lora-metadata-analysis")
    out_dir.mkdir(parents=True, exist_ok=True)

    df = load_metadata()

    if df.empty:
        print("No LoRa metadata found.")
        return

    df.to_csv(out_dir / "lora_uplink_metadata.csv", index=False)

    plt.figure(figsize=(10, 4))
    plt.plot(df["received_at"], df["spreading_factor"], marker="o")
    plt.title("Spreading Factor Over Time")
    plt.xlabel("Time")
    plt.ylabel("Spreading Factor")
    plt.grid(True)
    save_plot(out_dir / "sf_over_time.png")

    plt.figure(figsize=(10, 4))
    plt.plot(df["received_at"], df["estimated_bitrate_bps"], marker="o")
    plt.title("Estimated Raw LoRa Bit Rate Over Time")
    plt.xlabel("Time")
    plt.ylabel("Estimated bit rate [bit/s]")
    plt.grid(True)
    save_plot(out_dir / "estimated_bitrate_over_time.png")

    if df["rssi_dbm"].notna().any():
        plt.figure(figsize=(10, 4))
        plt.plot(df["received_at"], df["rssi_dbm"], marker="o")
        plt.title("RSSI Over Time")
        plt.xlabel("Time")
        plt.ylabel("RSSI [dBm]")
        plt.grid(True)
        save_plot(out_dir / "rssi_over_time.png")

    if df["snr_db"].notna().any():
        plt.figure(figsize=(10, 4))
        plt.plot(df["received_at"], df["snr_db"], marker="o")
        plt.title("SNR Over Time")
        plt.xlabel("Time")
        plt.ylabel("SNR [dB]")
        plt.grid(True)
        save_plot(out_dir / "snr_over_time.png")

    if df["rssi_dbm"].notna().any():
        plt.figure(figsize=(7, 4))
        plt.scatter(df["rssi_dbm"], df["spreading_factor"])
        plt.title("Spreading Factor vs RSSI")
        plt.xlabel("RSSI [dBm]")
        plt.ylabel("Spreading Factor")
        plt.grid(True)
        save_plot(out_dir / "sf_vs_rssi.png")

    if df["snr_db"].notna().any():
        plt.figure(figsize=(7, 4))
        plt.scatter(df["snr_db"], df["spreading_factor"])
        plt.title("Spreading Factor vs SNR")
        plt.xlabel("SNR [dB]")
        plt.ylabel("Spreading Factor")
        plt.grid(True)
        save_plot(out_dir / "sf_vs_snr.png")

    sf_counts = df["spreading_factor"].value_counts().sort_index()
    plt.figure(figsize=(7, 4))
    plt.bar(sf_counts.index.astype(str), sf_counts.values)
    plt.title("Spreading Factor Distribution")
    plt.xlabel("Spreading Factor")
    plt.ylabel("Number of uplinks")
    plt.grid(True, axis="y")
    save_plot(out_dir / "sf_distribution.png")

    freq_counts = df["frequency_hz"].value_counts().sort_index()
    plt.figure(figsize=(8, 4))
    plt.bar((freq_counts.index / 1_000_000).astype(str), freq_counts.values)
    plt.title("Frequency Distribution")
    plt.xlabel("Frequency [MHz]")
    plt.ylabel("Number of uplinks")
    plt.grid(True, axis="y")
    save_plot(out_dir / "frequency_distribution.png")

    summary = df.groupby("spreading_factor").agg(
        count=("spreading_factor", "count"),
        avg_rssi_dbm=("rssi_dbm", "mean"),
        avg_snr_db=("snr_db", "mean"),
        avg_estimated_bitrate_bps=("estimated_bitrate_bps", "mean"),
    ).reset_index()

    summary.to_csv(out_dir / "sf_summary.csv", index=False)

    print("LoRa metadata rows:", len(df))
    print(summary)
    print("Output written to:", out_dir)


if __name__ == "__main__":
    main()
