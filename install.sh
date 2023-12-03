#!/bin/bash

# Install Nginx
echo "Installing Nginx..."
sudo yum install epel-release -y
sudo yum install nginx -y
sudo systemctl start nginx --now
sudo systemctl status nginx
sudo systemctl enable nginx
echo "Nginx installation completed."

# Install MariaDB
echo "Installing MariaDB..."
sudo yum install -y mariadb-server mariadb-client
sudo systemctl start mariadb.service

# Wait for MariaDB to load for 10 seconds
sleep 10

# Secure the MariaDB installation
echo "Securing MariaDB..."
sudo mysql_secure_installation

# Prompt the user for confirmation before proceeding
echo "Press any key to continue to PHP installation..."
read -n 1 -s -p ""

# Install PHP
echo "Installing PHP..."

# Install Remi repository for PHP 7.4
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils

# Disable Remi PHP repositories for other versions
sudo yum-config-manager --disable 'remi-php*'

# Enable Remi PHP 7.4 repository
sudo yum-config-manager --enable remi-php74

# Install PHP and related modules
sudo yum install php php-cli php-fpm php-mysqlnd php-mysql php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json -y

# Start PHP-FPM service
sudo systemctl start php-fpm.service

# Enable PHP-FPM service to start automatically on system boot
sudo systemctl enable php-fpm.service

echo "PHP installation completed."
