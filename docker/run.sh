#!/usr/bin/env bash


MURANO=`docker ps -a -q --filter="name=murano"`

if [ "$MURANO" != "" ]
then
    echo "stop murano"
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi murano-dashboard
    docker rmi fiware-murano
fi
docker build -t fiware-murano .
export PASSWORD=$1
docker-compose -f docker-compose-nets.yml  up -d
