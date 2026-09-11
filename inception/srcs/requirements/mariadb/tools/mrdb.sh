#!/bin/bash

mkdir -p /run/mysqld #create mariadb runtime directory
chown -R mysql:mysql /run/mysqld #give mariadbpermission to use it 

if [ ! -d "/var/lib/mysql/mysql" ]; then #If MariaDB's system directory does not exist, do the following.
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql # Initialize MariaDB using the mysql user and put the database data in /var/lib/mysql.
fi

mysqld_safe --datadir=/var/lib/mysql & # Start MariaDB using /var/lib/mysql as its data directory.  & mean Run this command in the background.

until mariadb-admin ping --silent; do
    sleep 1
done

mariadb -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mariadb -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';"
mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

mysqladmin shutdown

exec mysqld_safe --datadir=/var/lib/mysql
