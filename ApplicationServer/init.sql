-- Table over devices with their EUI and location. The dev_eui is the unique identifier for each device and serves as the primary key.
CREATE TABLE IF NOT EXISTS end_devices(
    dev_eui TEXT PRIMARY KEY,
    location TEXT,

    CONSTRAINT dev_eui_unique UNIQUE (dev_eui)
);

-- Table for telemetry data with the columns expected by mqtt-listener.py and api.py
CREATE TABLE IF NOT EXISTS sensor_data (
    id SERIAL PRIMARY KEY,
    device_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    server_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    device_eui VARCHAR(50),
    ambient_temp NUMERIC(5,2),
    immediate_temp NUMERIC(5,2),
    conductor_temp NUMERIC(5,2),
    cpu_temp NUMERIC(5,2),
    raw_payload TEXT,

    -- Prevents duplicate telemetry measurements from being inserted
    CONSTRAINT unique_measurement UNIQUE (device_timestamp, device_eui)
);

-- B-tree index for efficient time-series queries by measurement time
CREATE INDEX IF NOT EXISTS idx_sensor_data_device_timestamp
ON sensor_data (device_timestamp);

-- B-tree index for efficient queries by device and time interval
CREATE INDEX IF NOT EXISTS idx_sensor_data_device_eui_timestamp
ON sensor_data (device_eui, device_timestamp);

-- Table for audit logs.
-- mqtt-listener.py uses event_type + description.
-- api.py uses event_type + performed_by + details.
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(50),
    performed_by VARCHAR(100),
    details TEXT,
    description TEXT
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user;

CREATE TABLE IF NOT EXISTS pending_recovery (
    device_eui TEXT PRIMARY KEY,
    app_id TEXT NOT NULL,
    start_ts BIGINT NOT NULL,
    end_ts BIGINT NOT NULL,
    last_requested_at DOUBLE PRECISION NOT NULL,
    retry_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE sensor_data
ADD CONSTRAINT fk_sensor_end_device
  FOREIGN KEY (device_eui)
  REFERENCES end_devices(dev_eui)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

ALTER TABLE pending_recovery
ADD CONSTRAINT fk_pending_end_device
  FOREIGN KEY (device_eui)
  REFERENCES end_devices(dev_eui)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

-- Indexes to speed up pending_recovery scans and age-based checks
CREATE INDEX IF NOT EXISTS idx_pending_recovery_updated_at
ON pending_recovery (updated_at);

CREATE INDEX IF NOT EXISTS idx_pending_recovery_last_requested_at
ON pending_recovery (last_requested_at);