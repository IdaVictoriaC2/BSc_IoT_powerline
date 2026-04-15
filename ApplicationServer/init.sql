-- Tabellen til sensordata med alle de kolonner jeres listener forventer
CREATE TABLE IF NOT EXISTS sensor_data (
    id SERIAL PRIMARY KEY,
    received_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    device_eui VARCHAR(50),
    ambient_temp NUMERIC(5,2),
    immediate_temp NUMERIC(5,2),
    conductor_temp NUMERIC(5,2),
    cpu_temp NUMERIC(5,2),
    raw_payload TEXT,
    -- Sikrer mod dubletter (NFR: Dataintegritet)
    CONSTRAINT unique_measurement UNIQUE (received_at, device_eui)
);

-- Tabellen til audit logs med de korrekte kolonnenavne
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(50),
    performed_by VARCHAR(100),
    details TEXT,
    description TEXT -- Tilføjet fordi jeres listener bruger dette felt
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user;
