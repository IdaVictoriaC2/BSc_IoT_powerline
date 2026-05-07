# Setting up authentik

This guide restores the exported Authentik volumes and starts the stack. Docker Compose often prefixes volume names with the project name (for example `auth_authentik_postgres`), so restoring into a plain `authentik_postgres` volume may not be picked up by the stack. Follow these steps to detect the correct volume names and restore into them.

1) Put the `docker-compose.yml` and `dynamic/` files in a directory on the target host.

2) If you exported the database using `pg_dump` (recommended), follow these steps to restore the SQL dump into the target PostgreSQL volume. This avoids issues caused by raw filesystem copies of the Postgres data directory.

```powershell
# from the directory containing docker-compose.yml and the SQL dump file
# 1) Start only PostgreSQL so Compose creates the correct project-scoped volumes
docker compose up -d authentik-postgresql

# 2) Terminate existing connections to the target DB (connect to `postgres`)
docker compose exec authentik-postgresql psql -U authentik -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'authentik' AND pid <> pg_backend_pid();"

# 3) Drop and recreate the database (optional but recommended for clean restore)
docker compose exec authentik-postgresql psql -U authentik -d postgres -c "DROP DATABASE IF EXISTS authentik;"
docker compose exec authentik-postgresql psql -U authentik -d postgres -c "CREATE DATABASE authentik;"

# 4) Restore the SQL dump into the fresh database (PowerShell: use piping instead of '<')
Get-Content .\authentik_backup.sql | docker compose exec -T authentik-postgresql psql -U authentik -d authentik

# 5) Start the rest of the stack
docker compose up -d
```

## Access the web interface 

at [http://localhost:9001](http://localhost:9001) and log in with (akadmin/<our_password>).

    NS-adm
    our_password

    AS-adm
    our_password
