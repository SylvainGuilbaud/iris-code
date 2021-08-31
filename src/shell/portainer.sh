docker run --detach \
 --name portainer \
 --publish 9009:9000 \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 portainer/portainer-ce
