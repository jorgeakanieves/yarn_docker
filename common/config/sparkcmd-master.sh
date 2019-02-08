#!/bin/bash

export USER=hadoop
source .profile
if [[ $1 = "start" ]]; then
  ~/spark/sbin/start-master.sh
  exit
fi

if [[ $1 = "stop" ]]; then
  ~/spark/sbin/stop-master.sh
fi
