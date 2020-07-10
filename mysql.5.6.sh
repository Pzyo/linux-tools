#!/bin/bash
#check your yum source
if [ ! -d "/data" ]; then
  mkdir /data
fi
yum repolist > /dev/null
if [ $? -eq 0 ];
then
    echo "yum check success and will be install mysql."
else
    echo " please check your yum source."
fi
#uninstall mariadb to avoid impact
tem=$(rpm -qa | grep mariadb)
for item in $tem
do
    rpm -e $item --nodeps
done
if [ $? -eq 0 ];
then
    echo "Next will be installed mysql5.6.37" 
else
    echo "please check your variable"
fi
#install mysql Rely on rpm 
yum -y install { gcc gcc-c++ gcc-g77 autocong automake zlib* fiex* libxml* ncurses-devel libmcrypt* libtool-ltdl-devel* make cmake* bison } > /dev/null
#install mysql start
#mkdir /data/
cd /data/
wget http://ftp.ntu.edu.tw/MySQL/Downloads/MySQL-5.6/mysql-5.6.40.tar.gz
tar -xf mysql-5.6.40.tar.gz > /dev/null
cd /data/mysql-5.6.40/
echo "请稍等，不要断开脚本，成功会有输出。"
cmake \
 -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
 -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
 -DDEFAULT_CHARSET=utf8 \
 -DDEFAULT_COLLATION=utf8_general_ci \
 -DWITH_INNOBASE_STORAGE_ENGINE=1 \
 -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
 -DMYSQL_DATADIR=/data/mysqldb \
 -DMYSQL_TCP_PORT=3306  > /dev/null
if [ $? -eq 0 ];
then
    echo "cmake complete."
else
    echo "please clean CMakeCache.txt and Repetitive operation."
fi
make > /dev/null
if [ $? -eq 0 ];
then
    echo "make complete."
else
    echo "make appear error please check this error."
fi
make install > /dev/null
if [ $? -eq 0 ];
then
    echo "install complete."
else
    echo "please Please check the make and reinstall."
fi
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
chown -R mysql:mysql /usr/local/mysql
chown mysql:mysql /data/mysqldata
cp /data/mysql-5.6.40/support-files/mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
cp /data/mysql-5.6.40/support-files/my-default.cnf /etc/my.cnf
echo -e " [mysqld] \n basedir =/usr/local/mysql \n datadir =/data/mysqldata \n port =3306 \n user=mysql \n log-error=/var/log/mysqld.log \n pid-file=/usr/local/mysql/mysqld.pid \n default-storage-engine=INNODB \n character_set_server=utf8 \n socket=/usr/local/mysql/mysql.sock \n " > /etc/my.cnf
echo -e "PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:\$PATH  export PATH " >> /etc/profile
source /etc/profile
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf > /dev/null
if [ $? -eq 0 ];
then
    echo " mysqldb Initialize the complete and welcome mysql."
else
    echo " mysqldb Initialize failed please check the error."
fi
service mysql restart
if [ $? -eq 0 ];
then
    echo "mysql install complete and welcom use mysql."
else
    echo "mysql start failed and please check the error."
fi
chkconfig mysql on



