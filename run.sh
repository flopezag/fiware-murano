#!/usr/bin/env bash


MURANO=`docker ps -a -q --filter="name=murano"`

if [ "$MURANO" != "" ]
then
    echo "stop murano"
    docker stop $(docker ps -a -q)
    docker rm -v $(docker ps -a -q)
    docker rmi fiware-murano
fi

docker build -t fiware-murano fiwaremurano
export PASSWORD=$1
docker-compose -f docker-compose-nets.yml up -d
