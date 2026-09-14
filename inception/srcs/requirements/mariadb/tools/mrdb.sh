#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql 
fi

mysqld_safe --datadir=/var/lib/mysql & 

until mariadb-admin ping --silent; do 
    sleep 1 
done

mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

mariadb-admin   shutdown 
exec mysqld_safe --datadir=/var/lib/mysql
