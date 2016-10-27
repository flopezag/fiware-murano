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
export RABBIT_HOST=$2
export RABBIT_LOGIN=$3
export RABBIT_PASSWORD=$4
docker-compose -f docker-compose-nets.yml  up -d
