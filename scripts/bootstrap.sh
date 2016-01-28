#!/bin/bash
# Setup script in order to provision Vagrant box

# CPR : Jd Daniel :: Ehime-ken
# MOD : 2016-01-27 @ 19:28:27
# REF : https://goo.gl/a5ZUqx
# VER : Version 1.0.1-dev


# Suppress some of the noise
export DEBIAN_FRONTEND=noninteractive


# Update Apt
# --------------------
apt-get update


# Install Apache & PHP (v5.5.9 latest)
# --------------------
apt-get install -y apache2 php5 libapache2-mod-php5 ## last is the apache -> php module

# Install commonly used modules
apt-get install -y php5-mysqlnd php5-curl php5-xdebug php5-gd php-pear php5-imap php5-mcrypt php5-sqlite php5-tidy php5-xmlrpc php5-xsl php-soap
php5enmod mcrypt


# Install GIT
# --------------------
apt-get install -y git


# Delete default apache web dir and symlink mounted vagrant dir from host machine
# --------------------
rm -rf /var/www/html /vagrant/httpdocs
mkdir -p /vagrant/httpdocs


# Symlink outer vagrant folder to webroot
# --------------------
ln -fs /vagrant/httpdocs /var/www/html


# Replace contents of default Apache vhost
# --------------------
VHOST=$(cat <<EOF
Listen 8080
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:8080>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)


echo -e "$VHOST" > /etc/apache2/sites-enabled/000-default.conf
echo -e "127.0.0.1 \t localhost" > /etc/hosts
a2enmod rewrite
service apache2 restart


# Install modern Mysql
# --------------------
apt-get -q -y install mysql-server-5.5

sed -i -e 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
service mysql restart


# Create a God mode user
# NOTE: You can now log into mysql from your external using
# NOTE: mysql -h {private_ip} -u godmode
# --------------------
mysql -u root -e "CREATE USER 'godmode'@'localhost'"
mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO 'god' @ 'localhost' WITH GRANT OPTION"

mysql -u root -e "CREATE USER 'godmode'@'%'"
mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO 'god' @ '%' WITH GRANT OPTION"

mysql -u root -e "FLUSH PRIVILEGES"


# Load PHP Info
# --------------------
echo '<?php phpinfo();' > /vagrant/httpdocs/index.php
