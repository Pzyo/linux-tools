#!/bin/bash

#
#  每秒输出/目录下所有目录文件
#

#echo "##### 简单暴力版 #####"
#for i in `ls /`
#do
#  echo $i
#  sleep 1
#done

echo "##### 自行进阶版 #####"
for i in `find / -maxdepth 1 -type d`
do
  echo $i
  sleep 1
done
