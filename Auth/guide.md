# Setting up authentik

Extract the compose/dynamic files
Then extract volumes before starting
```powershell
docker volume create authentik_postgres
docker volume create authentik_redis

docker run --rm -v authentik_postgres:/volume -v ${PWD}:/backup alpine tar xzf /backup/authentik_postgres.tar.gz -C /volume

docker run --rm -v authentik_redis:/volume -v ${PWD}:/backup alpine tar xzf /backup/authentik_redis.tar.gz -C /volume
```

Now start the stack
```powershell 
docker compose up -d
```

## Access the web interface 

at [http://localhost:9001](http://localhost:9001) and log in with (akadmin/<our_password>).

    NS-adm
    our_password

    AS-adm
    our_password
