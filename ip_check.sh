#!/bin/bash

#
# 检查某个网段的IP是否在线
#

IP='192.168.0'

for i in {1..254}
do
  ping $IP.$i -c 1 -w 2s &> /dev/null
  if [ $? -eq 0 ]
  then
    echo -e "\033[40m$IP.$i is online \033[0m"
  else
    echo -e "\033[42m$IP.$i is not online\033[0m"
  fi
done
