#!/bin/bash

DOCKER_MACHINE_IP=$(docker-machine ip default)

OAUTH_SERVER_HOSTNAME=${DOCKER_MACHINE_IP}
OAUTH_SERVER_PORT=9999
REVIEWS_SERVER_HOSTNAME=${DOCKER_MACHINE_IP}
REVIEWS_SERVERPORT=8081
RECOMMENDATIONS_SERVER_HOSTNAME=${DOCKER_MACHINE_IP}
RECOMMENDATIONS_SERVER_PORT=8082

header() {
    echo "================================================================================"
    echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
    echo "================================================================================"

}

header "Running MongoDB"
docker run --detach --publish 27017:27017 --publish 28017:28017 -e AUTH=no ursuad/docker-mongodb

header "Running Neo4J"
docker run  --detach --publish=7474:7474  ursuad/docker-neo4j

header "Running RabbitMQ"
docker run --detach  -p 5672:5672 -p 15672:15672 ursuad/docker-rabbitmq

header "Runnig Sprin Cloud Config Server"
docker run --detach --publish 8888:8888 ursuad/tutorial-springbox-config-server
# Sleep for 30 seconds 
sleep 30

header "Running Eureka"
docker run --detach -p 8761:8761 -e APPLICATION_DOMAIN=192.168.99.100 ursuad/tutorial-springbox-eureka
sleep 30

header "Springbox Auth Server"
docker run --detach --publish 9999:9999 ursuad/tutorial-springbox-auth-server
sleep 30

header "Running Springbox Catalog"
docker run --detach --publish 8080:8080 -e CONFIG_SERVER_HOST=192.168.99.100 -e CONFIG_SERVER_PORT=8888 ursuad/tutorial-springbox-catalog 
sleep 30

header "Running Springbox reviews"
docker run --detach --publish 8081:8081 -e CONFIG_SERVER_HOST=192.168.99.100 -e CONFIG_SERVER_PORT=8888 ursuad/tutorial-springbox-reviews
sleep 30

header "Running Springbox recommendations"
docker run --detach --publish 8082:8082 -e CONFIG_SERVER_HOST=192.168.99.100 -e CONFIG_SERVER_PORT=8888 ursuad/tutorial-springbox-recommendations
sleep 30

header "Running Springbox api gateway"
docker run --detach --publish 9000:9000 -e CONFIG_SERVER_HOST=192.168.99.100 -e CONFIG_SERVER_PORT=8888 ursuad/tutorial-springbox-api-gateway

header "Loading some data into the DBs"

source springbox-reviews/scripts/loadReviews.sh ${OAUTH_SERVER_HOSTNAME} ${OAUTH_SERVER_PORT} ${REVIEWS_SERVER_HOSTNAME} ${REVIEWS_SERVERPORT} 
cd springbox-recommendations/scripts/
source loadGraph.sh ${OAUTH_SERVER_HOSTNAME} ${OAUTH_SERVER_PORT} ${RECOMMENDATIONS_SERVER_HOSTNAME} ${RECOMMENDATIONS_SERVER_PORT} 

echo "All done. Check http://192.168.99.100:9000"
echo "You can login with user:mstine pass:secret"
