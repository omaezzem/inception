#!/bin/bash

# mariadb needs a place to store its actual database data. this place is /var/lib/mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql #"MariaDB, prepare your database files inside /var/lib/mysql, and make mysql the Linux user associated with those files."
fi

mysqld_safe --datadir=/var/lib/mysql & # & katgol: "Start MariaDB f background, w khallini nkemel l-script."

until mariadb-admin ping --silent; do #--silent ghir kaykhelli ping ma y3amarch terminal b messages kol mara.
    sleep 1  # ping one mariadb to see if his ready .
done

mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" #e mean execute this sql commande
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" #GRANT it mean 3ti l permissions 

# % kat3ni: "Had user y9der yconnecta men ay host."
#because mariadb created by 'username'@'host' so use user@% mean this user can connect men ayi host 

#mariadb-admin howa tool kay3tik control 3la MariaDB server.

mariadb-admin   shutdown 
exec mysqld_safe --datadir=/var/lib/mysql
