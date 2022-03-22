mkdir -p  ${HOME}/data/pgadmin
sudo chown -R 5050:5050  ${HOME}/data/pgadmin

docker run -p 80:80 \
    -v  ${HOME}/data/pgadmin:/var/lib/pgadmin \
    -e 'PGADMIN_DEFAULT_EMAIL=henke@houseid.se' \
    -e 'PGADMIN_DEFAULT_PASSWORD=password' \
    --name pgadmin \
    --restart=always \
    -d dpage/pgadmin4