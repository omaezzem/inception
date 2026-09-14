#!/bin/bash

set -e #Ila chi command f script failed, wa9ef script

mkdir -p /run/php

cd /var/www/html

until mysqladmin ping \
    -h mariadb \
    -P 3306 \
    -u"$MYSQL_USER" \
    -p"$MYSQL_PASSWORD" \
    --silent
do
    echo "wait until mariadb starts"
    sleep 1
done

echo "MariaDB is ready!"

if [ ! -f /var/www/html/wp-config.php ]; then

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="$URL" \
        --title="Inception" \
        --admin_user="$WP_AD_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_USER_EMAIL" \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --role=subscriber \
        --user_pass="$WP_PASS" \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F
