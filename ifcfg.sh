#!/bin/bash

# 网段
IP_SET="192.168.10"
# 生成文件的存储位置
ifcfg_path="/root/ifcfg"
# 网卡配置文件
ifcfg_default_path="/etc/sysconfig/network-scripts/ifcfg-ens33"

mkdir $ifcfg_path &>/dev/null

for ((i=1;i<=10;i++))
do
  ip_tmp=`expr 100 + $i`
  tmp=`expr 33 + $i`
  cp $ifcfg_default_path  $ifcfg_path/ifcfg-ens$tmp
  sed -i "s/NAME.*/NAME=ens$tmp/g" $ifcfg_path/ifcfg-ens$tmp
  sed -i "s/DEVICE.*/DEVICE=ens$tmp/g" $ifcfg_path/ifcfg-ens$tmp
  sed -i "s/IPADDR.*/IPADDR=192.168.10.$ip_tmp/g" $ifcfg_path/ifcfg-ens$tmp
done
