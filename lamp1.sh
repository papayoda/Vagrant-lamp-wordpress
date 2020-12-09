#!/bin/bash

#update system
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade

#install packets
sudo apt install apache2 mariadb-server php php-cli php-mysql libapache2-mod-php php-mbstring openssh-server net-tools unzip avahi-daemon -y
sudo ufw allow in "Apache Full"
sudo ufw allow ssh
sudo systemctl enable apache2
sudo systemctl start apache2
sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo systemctl restart apache2
sudo chmod -R 0755 /var/www/html/ 
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
