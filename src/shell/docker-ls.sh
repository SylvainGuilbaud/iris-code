docker run --rm carinadigital/docker-ls:latest
# docker-ls repositories --registry https://containers.intersystems.com --user $USERNAME --password $PASSWORD
docker-ls repositories --registry https://containers.intersystems.com 
docker-ls tags --registry https://containers.intersystems.com intersystems/irishealth-community 
docker-ls tags --registry https://containers.intersystems.com intersystems/irishealth 
docker-ls tags --registry https://containers.intersystems.com intersystems/iris-community
docker-ls tags --registry https://containers.intersystems.com intersystems/iris 
