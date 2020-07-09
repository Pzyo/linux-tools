#!/bin/bash

#
# 自动编译安装nginx 1.18
# 编译安装前，请确定系统与本地光盘已经连接
# 将脚本与nginx 1.18 源码包存放在同一目录下
#

echo "###### 检查yum环境... ..."
yum clean all &>/dev/null && yum makecache &>/dev/null
#yum repolist
if [ $? -ne 0 ]
then
df -h | grep sr0
if [ $? -ne 0 ]
then
mkdir /iso 2>/dev/null
mount /dev/sr0 /iso 1>/dev/null
fi
touch /etc/yum.repos.d/base.repo 2>/dev/null
cat >/etc/yum.repos.d/base.repo<<EOF
[base]
name=local_yum
baseurl=file:///iso
gpgcheck=0
enabled=1
EOF
yum clean all &>/dev/null && yum makecache &>/dev/null
fi

mkdir /data 2>/dev/null
tar xf nginx-1.18.0.tar.gz -C /data
cd /data/nginx-1.18.0

groupadd -r www
useradd -r -g www -s /sbin/nologin -M www

echo "###### 安装nginx环境... ..."
yum install -y gcc gcc-c++ automake openssl openssl-devel curl curl-devel bzip2 bzip-devel make pcre-devel &>/dev/null
echo "###### configure ... ..."
./configure --prefix=/usr/local/nginx \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-http_ssl_module \
            --with-http_memcached_module \
            --with-ipv6 \
            --with-pcre \
            --with-http_gzip_static_module \
            --with-http_realip_module \
            --with-http_flv_module \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/usr/local/nginx/conf/nginx.conf \
            --user=www \
            --group=www 1>/dev/null
echo "###### 编译安装ing ... ..."
make 1>/dev/null && make install 1>/dev/null
if [ $? -eq 0 ]
then
  echo "###### nginx编译安装成功"
fi

###### nginx开机自启动
echo "nginx" >> /etc/rc.d/rc.local
chmod u+x /etc/rc.d/rc.local

nginx
tmp=`netstat -ntlp | grep nginx | wc -l`
if [ $tmp -eq 1 ]
then
  echo "###### nginx启动成功"
fi
