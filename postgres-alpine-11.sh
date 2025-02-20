docker stop postgres

docker rm postgres

docker run --name postgres --restart=always -v `pwd`/db/pgdata119-alpine:/var/lib/postgresql/data -v `pwd`/db/db-dump:/docker-entrypoint-initdb.d -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:11.9-alpine