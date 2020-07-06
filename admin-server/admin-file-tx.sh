#!/bin/bash

list="/root/shell/host.list"

if [ $# -ne 2 ]
then
    echo "请填写要发送的文件以及远程主机的位置 eg：./admin-file-tx.sh filename remote"
    exit 1
fi

if [ ! -e $1 ]
then
    echo "文件不存在！"
    exit 1
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
        ip=`sed -n '/'$num'/,/^[[]/{p}' $list | grep "^[0-9]"`
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
    scp -r $1 $i:$2
done
