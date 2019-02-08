#!/bin/bash

# Bring the services up
function startServices {
  docker start worker2
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d worker1 /home/hadoop/sparkcmd-slave.sh start
}

if [[ $1 = "start" ]]; then
  startServices
  exit
fi


if [[ $1 = "deploy" ]]; then
  docker rm -f `docker ps -aq` # delete old containers
  echo ">> Starting nodes worker nodes ..."
  docker run -d --hostname <HOSTNAME> --add-host master:<IPHOST> -p 2123:2123 -p 9864-9867:9864-9867 -p 2123:2123 -p 8042:8042 -p 4040:4040 -p 8081:8081 --name worker3 -it worker3
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start - create a new Docker network"
#echo "                 start  - start the existing containers"
#echo "                 stop   - stop the running containers"