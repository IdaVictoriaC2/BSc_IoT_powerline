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
