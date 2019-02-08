# Hadoop/ Spark cluster deployed as Docker containers

Multinode docker installation without container orchestration

Each role services is deployed in a different host

The installation takes care of the Hadoop & Spark configuration

## Requerimients
Port 2123 opened on all hosts

## Required infrastructure:
Hosts B1, B2, B3

8 CPU / 270GB HDD / 32GBRAM

RHEL 7.4 with Docker 1.3.1


## Services Distribution:

B1 (master) -> node1 (master)

B2 (worker) -> node2

B3 (worker) -> node3



### B1:

Hadoop-hdfs-namenode

Hadoop-hdfs-datanode

Hadoop-yarn-resourcemanager

Spark

ElasticSearch

Kibana

Backoffice (Springboot : Front + API)

Hadoop-hdfs-datanode

Hadoop-yarn-nodemanager

### B2:

Hadoop-hdfs-datanode

Hadoop-yarn-nodemanager

### B3:

Hadoop-hdfs-datanode

Hadoop-yarn-nodemanager



## Main Components versions

Spark 2.3.1

Hadoop 3.1.0


## Installation

### B1 node:

1) Clone (/apps) this repository on node B1 (master)

2) Change environment parameters:

  B1/cluster.sh ->   ip from nodes
  [172.22.4.161] -> XXX.XXX.XXX.XXX
  ...

  example:
  docker run -d --hostname <HOSTNAME> --add-host master:<MASTERIP> --name worker1 -p 2123:2123 -p 9864-9867:9864-9867 -p 4040:4040 -p 8081:8081 -it worker1

  docker run -d  --hostname master --link worker1 --add-host worker2:<WORKER2IP>  --add-host worker3:<WORKER3IP> --name master -p 7077:7077 -p 8080:8080 -p 8088:8088 -p 9000:9000 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 50200:50200 -p 9870:9870 -it master

  ...Same for each nodeX

3) Build images in B1 (master)

3.1) cd common/base && ./build.sh

3.2) cd B1/master && ./build.sh

3.3) cd B1/datanode1 && ./build.sh

4) cd B1/ && ./cluster.sh deploy

5) Check running docker containers:

78dff5b16102        sparkbase           "/bin/sh -c 'service…"   29 hours ago        Up 29 hours         0.0.0.0:7077->7077/tcp, 0.0.0.0:8030-8033->8030-8033/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:8088->8088/tcp, 0.0.0.0:9000->9000/tcp, 0.0.0.0:9870->9870/tcp, 2123/tcp, 0.0.0.0:50200->50200/tcp   nodemaster

681ce0cecc77        spark-datanode1     "/bin/sh -c 'service…"   29 hours ago        Up 29 hours         0.0.0.0:2123->2123/tcp, 0.0.0.0:9864-9867->9864-9867/tcp


### B2 node:

1) Clone (/apps) this repository on node B2 (worker)

2) Build images in B2 (worker) -> node2

2.1) cd B2/base && ./build.sh

2.2) cd B2/datanode2 && ./build.sh

3) cd B2/ && ./cluster.sh deploy

4) Check running docker containers:

69d3ec3af30a        sparkbase           "/bin/sh -c 'servi..."   47 hours ago        Up 47 hours         0.0.0.0:2123->2123/tcp, 9000/tcp   node3


### B3 node:

1) Clone (/apps) this repository on node B3 (worker)

2) Build images in B3 (worker) -> node3

2.1) cd B3/base && ./build.sh

2.2) cd B3/datanode3 && ./build.sh

3) cd B3/ && ./cluster.sh deploy

4) Check running docker containers:

5fa49d83e81c        sparkbase           "/bin/sh -c 'servi..."   22 hours ago        Up 22 hours         0.0.0.0:2123->2123/tcp, 9000/tcp   node3


### B1  -start services-

1) cd B1/ && ./cluster.sh start

2) Check all services running on containers from each node:

master

hadoop      278      1  8 08:27 ?        00:00:06 /docker-java-home/bin/java -Dproc_namenode -Djava.net.preferIPv4Stack=true -Dhdfs.audit.logger=INFO,NullApp

hadoop      520      1  5 08:27 ?        00:00:04 /docker-java-home/bin/java -Dproc_secondarynamenode -Djava.net.preferIPv4Stack=true -Dhdfs.audit.logger=INF

hadoop      791      0 13 08:27 ?        00:00:08 /docker-java-home/bin/java -Dproc_resourcemanager -Djava.net.preferIPv4Stack=true -Dservice.libdir=/home/ha

datanode1

hadoop       89      1  2 08:27 ?        00:00:04 /docker-java-home/bin/java -Dproc_datanode -Djava.net.preferIPv4Stack=true -Dhadoop.security.logger=ERROR,R

hadoop      209      1  5 08:27 ?        00:00:07 /docker-java-home/bin/java -Dproc_nodemanager -Djava.net.preferIPv4Stack=true -Dyarn.log.dir=/home/hadoop/h

hadoop      366      0  2 08:27 ?        00:00:03 /docker-java-home/bin/java -cp /home/hadoop/spark/conf/:/home/hadoop/spark/jars/*:/home/hadoop/hadoop/etc/h

### B2  -start spark slave-

1) cd B2/ && ./cluster.sh start

2) Check all services running on containers from each node:

hadoop       99      1  0 08:25 ?        00:00:10 /docker-java-home/bin/java -Dproc_datanode -Djava.net.preferIPv4Stack=true -Dhadoop.security.logger=ERROR,R

hadoop      208      1  0 08:25 ?        00:00:21 /docker-java-home/bin/java -Dproc_nodemanager -Djava.net.preferIPv4Stack=true -Dyarn.log.dir=/home/hadoop/h

hadoop       86      0 49 09:48 ?        00:00:02 /docker-java-home/bin/java -cp /home/hadoop/spark/conf/:/home/hadoop/spark/jars/*:/home/hadoop/hadoop/etc/h

...(Same for nodes left)

# Warning! This will remove everything from HDFS
cluster.sh deploy # Format the cluster and deploy images again
```
