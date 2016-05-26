#!/usr/bin/env bash


MURANO=`docker ps -a -q --filter="name=murano"`

if [ "$MURANO" != "" ]
then
    echo "stop murano"
    docker stop $(docker ps -a -q)
    docker rm -v $(docker ps -a -q)
    docker rmi fiware-murano
fi
cd ../fiwaremurano
docker build -t fiware-murano .
export PASSWORD=$1
docker-compose -f docker-compose-nets.yml up -d
