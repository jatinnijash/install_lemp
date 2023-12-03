#!/bin/bash

# Install EPEL repository
sudo yum install epel-release -y

# Install Nginx
sudo yum install nginx -y

# Start Nginx service
sudo systemctl start nginx --now

# Check Nginx service status
sudo systemctl status nginx

# Enable Nginx service to start automatically on system boot
sudo systemctl enable nginx


#!/bin/bash

# Install Nginx
echo "Installing Nginx..."
sudo yum install epel-release -y
sudo yum install nginx -y
sudo systemctl start nginx --now
sudo systemctl status nginx
sudo systemctl enable nginx
echo "Nginx installation completed."

# Wait for MariaDB to load for 10 seconds
sleep 10

# Clear the screen and start fresh
clear

# Install MariaDB
echo "Installing MariaDB..."
sudo yum install -y mariadb-server mariadb-client
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service



# Secure the MariaDB installation
sudo mysql_secure_installation
