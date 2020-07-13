#!/bin/bash

#
# 检查Nginx进程是否正常，否则不正常
#

tmp=`ps aux | grep "\<nginx\>" |wc -l`

if [ $tmp -eq 1 ]
then
  echo "Nginx不存活，尝试重启... ..."
  nginx
else
  echo "Nginx正常运行"
fi
