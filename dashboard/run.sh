#!/usr/bin/env bash



MURANO=`docker ps -a -q --filter="name=murano"`
echo $MURANO
if [ "$MURANO" != "" ]
then
    echo "stop murano"
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi murano-dashboard
    docker rmi fiware-murano
fi
cd ../fiwaremurano
docker build -t fiware-murano .
cd ../dashboard
docker build -t murano-dashboard .
export PASSWORD=$1
docker-compose -f docker-compose-dashboard.yml up&