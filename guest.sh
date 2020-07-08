#!/bin/bash

echo "猜数游戏"
echo "猜测范围1-10"
#echo "最多失败5次"

#tmp=`shuf -i 1-10 -n 1`
tmp=$[RANDOM%10+1]

#for ((i=1;i<=5;i++))
#do
  read -p "输入你要猜测的数字：" num
  if [ $num -eq $tmp ]
  then
    echo "恭喜你猜对了"
    exit 1
  elif [ $num -lt $tmp ]
  then
    echo "你输入的数字小了"
  else
    echo "你输入的数字大了"
  fi
#done
