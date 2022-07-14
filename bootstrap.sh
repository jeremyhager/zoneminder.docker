#!/bin/sh

# prereqs
## Apache
apt install -y apache2
ufw allow in "Apache"

## mysql-server
apt install -y mysql-server

## php
apt install -y php libapache2-mod-php php-mysql

## ppa
add-apt-repository -y ppa:iconnor/zoneminder-master

## updates
apt update -y
apt upgrade -y
apt dist-upgrade

# Configure MySQL
rm /etc/mysql/my.cnf
cp /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/\[mysqld\]/\[mysqld\]\nsql_mode = NO_ENGINE_SUBSTITUTION/' /etc/mysql/my.cnf
systemctl restart mysql

# Zoneminder
apt-get install -y zoneminder
chmod 740 /etc/zm/zm.conf
chown root:www-data /etc/zm/zm.conf
chown -R www-data:www-data /usr/share/zoneminder/

## Apache
a2enmod cgi
a2enmod rewrite
a2enconf zoneminder

## Improve caching
a2enmod expires
a2enmod headers

## Restart apache to apply configs
systemctl restart apache2


## enable and start Zoneminder
systemctl enable zoneminder
systemctl start zoneminder

# For now, set timezone to UTC
sed -i 's/;date.timezone =/date.timezone = Etc\/UTC/' /etc/php/*/apache2/php.ini
systemctl reload apache2