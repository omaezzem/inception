#!/bin/bash

set -e

mkdir -p /run/php

if [ ! -f /var/www/html/wp-config.php ]; then

    cat > /var/www/html/wp-config.php <<EOF
<?php

define('DB_NAME', '${MYSQL_DATABASE}');
define('DB_USER', '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_HOST', 'mariadb:3306');

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         'change-this-key');
define('SECURE_AUTH_KEY',  'change-this-key');
define('LOGGED_IN_KEY',    'change-this-key');
define('NONCE_KEY',        'change-this-key');
define('AUTH_SALT',        'change-this-salt');
define('SECURE_AUTH_SALT', 'change-this-salt');
define('LOGGED_IN_SALT',   'change-this-salt');
define('NONCE_SALT',       'change-this-salt');

\$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
EOF

fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F