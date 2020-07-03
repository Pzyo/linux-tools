#!/bin/bash

## 批量管理命令 v1.0 ##

list="/root/shell/host.list"

if [ $# -lt 1 ]
then
    echo "请添加远程指令 eg：./admin-cmd.sh cmd1 [-ops]"
    exit 1
fi

if [[ "$*" =~ ^(rm|init|userdel) ]]
then
    echo -e "****\033[1;5;31m 正在进行敏感操作 \033[0m******"
fi

echo "--------------------------------"
cat -n $list
echo "--------------------------------"
read -p "请输入要执行的主机编号或者组名，输入ALL发送到所有主机：" num

ip=""
if [ "$num" = "ALL" ]
then
    ip=`cat $list | grep "^[0-9]"`
elif [ ! "$num" = "ALL" ] && [[ "$num" =~ ^[a-Z] ]]
then
    res=`grep $num $list | wc -l`
    if [ $res -eq 0 ]
    then
        echo "分组不存在！"
        exit 1
    else
        ip=`sed -n '/'$num'/,/^[[]/{p}' host.list | grep "^[0-9]"`
    fi  
else
    if [[ `echo $list | awk 'NR=='$num'{print $0}'` =~ [a-Z] ]]
    then
        echo "所选num出错"
        exit 1
    fi
    for i in `echo $num`
    do
        ip="$ip `cat -n $list | awk 'NR=='$i'{print $NF}'`"
    done
fi

for i in `echo $ip`
do
    echo -e "** 正在连接：\033[1;31m $i \033[0m **************"
    ssh $i "$*"
done
