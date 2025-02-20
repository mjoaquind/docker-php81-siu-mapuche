docker stop mapuche

docker rm mapuche

docker run --name mapuche --restart=always -v `pwd`/data:/data -p "80:80" --link postgres:postgres -d php81-mapuche
