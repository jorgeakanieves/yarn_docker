#!/bin/bash

export USER=hadoop
source .profile
if [[ $1 = "start" ]]; then
  ~/spark/sbin/start-slave.sh master:7077
  exit
fi

if [[ $1 = "stop" ]]; then
  ~/spark/sbin/stop-slave.sh
fi
