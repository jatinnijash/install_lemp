#!/bin/bash

# Install Nginx
echo "Installing Nginx..."
sudo yum install epel-release -y
sudo yum install nginx -y
sudo systemctl start nginx --now
sudo systemctl status nginx
sudo systemctl enable nginx
echo "Nginx installation completed."
clear

# Install MariaDB
echo "Installing MariaDB..."
sudo yum install -y mariadb-server mariadb-client
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Wait for MariaDB to load for 10 seconds
sleep 10

# Secure the MariaDB installation
echo "Securing MariaDB..."
sudo mysql_secure_installation

# Prompt the user for confirmation before proceeding
echo "Press any key to continue to PHP installation..."
read -n 1 -s -p ""

# Clear the screen before proceeding to PHP installation
clear

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

# Clear the screen before proceeding to phpmyadmin installation

sleep 10
clear

# Install phpMyadmin
echo "Installing phpMyadmin..."
sudo yum -y install phpmyadmin

sleep 10
clear

echo "PHP and phpMyadmin installation completed."

# Clear the screen before proceeding to nginx configure
clear

# configure Nginx
echo "configure Nginx..."

# Download the default.conf file from GitHub
wget -O default.conf https://raw.githubusercontent.com/jatinnijash/install_lemp/main/default.conf

# Check if the file exists in the current directory
if [ ! -f default.conf ]; then
  echo "File 'default.conf' not found in the current directory."
  exit 1
fi

# Copy the modified file to /etc/nginx/conf.d/default.conf
sudo cp default.conf /etc/nginx/conf.d/default.conf

echo "File 'default.conf' copied to /etc/nginx/conf.d/default.conf."

sleep 5
clear

echo "Create soft-link phpMyadmin..."
sudo ln -s /usr/share/phpMyAdmin /usr/share/nginx/html

sleep 10

echo "permission to session."
sudo chown -R nginx:nginx /var/lib/php/session 

sleep 5
clear

# Backup the original file
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Use sed to replace the line with the new value
sed -i '/worker_processes auto;/c worker_processes 1;' /etc/nginx/nginx.conf

# Restart Nginx to apply the changes
sudo systemctl restart nginx

echo "Nginx configuration updated."

clear
# Configure firewall
echo "Configuring firewall..."
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

sleep 5
clear

echo "configure nginx www.conf"

# Change the user to nginx
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf

# Change the group to nginx
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf

# Change the listen value to /var/run/php-fpm/php-fpm.sock
sed -i 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fpm.sock/g' /etc/php-fpm.d/www.conf

# Replace "nobody" with "nginx" for listen.owner and listen.group
sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf

# Restart php-fpm to apply the changes
systemctl restart php-fpm




