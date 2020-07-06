#!/bin/bash

#
# SSH登录失败次数超过5次的，被记录并屏蔽连接
#

bad_ip="/root/bad_ip.list"

while [ 1 -lt 2 ]
do
  for i in `lastb | awk '/\<ssh\>/{IP[$3]++}END{for(i in IP){if(IP[i]>5)print i}}' | xargs`
  do
    res=`grep "$i" $bad_ip | wc -l`
    if [ $res -eq 0 ]
    then
      echo $i >>  $bad_ip
      iptables -t filter -A INPUT -s $i -j DROP
    fi
  done
  sleep 10
done
