# Setting up the Authentication Server

This guide restores the Authentik PostgreSQL dump and starts the stack.

1) Put the `docker-compose.yml`, `authentik_backup.sql` and `dynamic/` files in a directory on the target host.

2) Restore the dump and start the stack using the following commands:

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

# Configuration in authentik
The authentik admin and other users have the password IMbachelor26, which can be changed within the admin interface.