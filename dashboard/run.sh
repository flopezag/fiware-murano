#!/usr/bin/env bash

cd ../fiwaremurano
docker build -t fiware-murano .
cd ../dashboard
docker build -t murano-dashboard .
export PASSWORD=$1
docker-compose -f docker-compose-dashboard.yml up
