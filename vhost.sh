#!/bin/bash

nginx_path="/usr/local/nginx/conf"
vhost_path="/usr/local/nginx/conf/vhost"

mkdir $vhost_path 2>/dev/null

port=8000

for i in `awk -F: '{print $1}' /etc/passwd`
do
port=$((port+1))

touch $vhost_path/$i.conf
cat >$vhost_path/$i.conf<<EOF
server {
    listen $port;
    server_name $i.com;
    root /usr/local/nginx/html;
    index index.html index.htm index.php;
    location ~ [^/]\.php(/|$) {
         fastcgi_pass 127.0.0.1:9000;
         fastcgi_index index.php;
         include fastcgi.conf;
         }
         location /logs/ {
                auth_basic            "Restricted";
                auth_basic_user_file  htpasswd.nginx;
                alias  /home/wwwlogs/api.store.etcchebao.com/openlog/;
                autoindex on;
                autoindex_exact_size off;
                autoindex_localtime on;
    }
}
EOF

#cp $nginx_path/nginx.conf $vhost_path/$i.conf
#sed -i "s/listen.*/listen $port;/g" $vhost_path/$i.conf
#sed -i "s/server_name.*/server_name $i\.com;/g" $vhost_path/$i.conf

nginx -s reload
done
