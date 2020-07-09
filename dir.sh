#!/bin/bash

#
# 生成/etc/passwd下用户名对应的目录至/data
#

dir_path="/data"

mkdir $dir_path &>/dev/null

for i in `awk -F: '{print $1}' /etc/passwd`
do
  mkdir $dir_path/$i 2>/dev/null
done
