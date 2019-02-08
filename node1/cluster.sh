#!/bin/bash

# Bring the services up
function startServices {
  echo ">> Starting docker nodes..."
  docker start master worker1
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it master hadoop/sbin/start-dfs.sh
  sleep 5
  echo ">> Create hdfs pipeline paths"
  docker cp ../common/scripts/createPathsHdfs.sh master:/home/hadoop
  docker exec -u root -d master chown hadoop:hadoop /home/hadoop/createPathsHdfs.sh
  docker exec -u root -d master chmod +x /home/hadoop/createPathsHdfs.sh
  docker exec -u hadoop -d master hdfs dfsadmin -safemode leave
  docker exec -u hadoop -d master /home/hadoop/createPathsHdfs.sh
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d master hadoop/sbin/start-yarn.sh
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d master /home/hadoop/sparkcmd-master.sh start
  docker exec -u hadoop -d worker1 /home/hadoop/sparkcmd-slave.sh start
  echo "Hadoop Yarn info @ master: http://<HOSTNAME>:8088/cluster"
  echo "Spark info @ master : http://<HOSTNAME>:8080/"
  echo "Hadoop Namenode @ master : <HOSTNAME>:9870/"
  echo "Hadoop Datanode @ worker2 : <HOSTNAME>:9864/"
  echo "Spark job ui @ driver node : <HOSTNAME>:4040/jobs/"
}

if [[ $1 = "start" ]]; then
  # Format master
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it master hadoop/bin/hdfs namenode -format
  startServices
  exit
fi

#if [[ $1 = "stop" ]]; then
#  docker exec -u hadoop -d master /home/hadoop/sparkcmd.sh stop
#  docker exec -u hadoop -d worker1 /home/hadoop/sparkcmd.sh stop
#  docker exec -u hadoop -d node3 /home/hadoop/sparkcmd.sh stop
#  docker stop nodemaster node2 node3
#  exit
#fi

if [[ $1 = "deploy" ]]; then
  #docker rm -f `docker ps -aq` # delete old containers
  docker rm -f master worker1
  echo ">> Starting nodes master and worker nodes ..."
  docker run -d --hostname worker1  --name worker1 --net mynet  -p 2123:2123 -p 9864-9867:9864-9867 -p 4040:4040 -p 8081:8081 -it worker1
  docker run -d  --hostname master --add-host worker2:<IPHOST>  --add-host worker3:<IPHOST> --net mynet --name master -p 7077:7077 -p 8080:8080 -p 8088:8088 -p 9000:9000 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 50200:50200 -p 9870:9870 -it master
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start - create a new Docker network"
#echo "                 start  - start the existing containers"
#echo "                 stop   - stop the running containers"
