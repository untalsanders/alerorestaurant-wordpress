#!/usr/bin/env bash

set -e

sed -e "s|define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', 'wordpress' );|g" \
	-e "s|define( 'DB_USER', 'username_here' );|define( 'DB_USER', 'wordpressuser' );|g" \
	-e "s|define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', 'wordpresspass' );|g" \
	/var/www/wordpress/wp-config-sample.php > wp-config.php

sudo mv wp-config.php /var/www/wordpress/
sudo chown -R www-data: /var/www/wordpress
sudo mv wordpress /etc/nginx/sites-available/

echo -e "\h\ny\nwordpress\nwordpress\ny\ny\ny\ny" | sudo mysql_secure_installation

sudo mysql -u root -pwordpress -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -u root -pwordpress -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'wordpresspass';"
sudo mysql -u root -pwordpress -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'wordpresspass';"
sudo mysql -u root -pwordpress -e "FLUSH PRIVILEGES;"

sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/default
sudo service nginx restart

echo "|     WordPress Web Server Ready!     |"
echo "°-------------------------------------°"
echo "| Click here > http://localhost:8081  |"
echo "°-------------------------------------°"

