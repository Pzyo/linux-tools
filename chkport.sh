#!/bin/bash

#
# 检测端口是否被占用
#

read -p "输入检测的端口：" port

tmp=`netstat -ntl | grep "\<$port\>" | wc -l`
if [ $tmp -ge 1 ]
then
  service=`netstat -ntlp | grep "\<$port\>" | awk -F/ '{print $NF}' | cut -d ':' -f1 | uniq`
  echo "该端口占有服务，服务为：$service"
else
  echo "该端口没有被占用"
fi
