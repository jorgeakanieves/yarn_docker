#!/bin/bash
hdfs dfs -mkdir -p hdfs://master:9000/nfs/data-input/pngs
hdfs dfs -mkdir -p hdfs://master:9000/nfs/data-output/texts
hdfs dfs -mkdir -p hdfs://master:9000/nfs/data-output/classification
hdfs dfs -mkdir -p hdfs://master:9000/nfs/data-input/pdfs
hdfs dfs -mkdir -p hdfs://master:9000/data/input-pdf

hdfs dfs -mkdir -p /user/spark
hdfs dfs -mkdir -p /user/spark/applicationHistory
hdfs dfs -chmod 777 /user/spark
hdfs dfs -chmod 777 /user/spark/applicationHistory
hdfs dfs -mkdir -p /user/airflow
hdfs dfs -chmod 777 /user/airflow
hdfs dfs -chown airflow:airflow /user/airflow
hdfs dfs -chown spark:spark /user/spark
hdfs dfs -mkdir -p /user/hadoop

