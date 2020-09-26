#!/bin/bash

echo "bash start-stop.sh start-single-node [To run single node cluster]"
echo "bash start-stop.sh start-multi-node [To run multi node cluster]"
echo "bash start-stop.sh stop [To stop ELK cluster]"

if [ "$1" == 'start-single-node' ];then
docker-compose -f docker-compose-singlenode.yml up -d

elif [ "$1" == 'start-multi-node' ];then 
docker-compose -f docker-compose-multinode.yml up -d

elif [ "$1" == 'stop' ];then 
docker-compose -f docker-compose-multinode.yml down

fi