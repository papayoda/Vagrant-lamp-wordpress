#!/bin/bash
#update&upgrade
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade

#asking for a database name & a db user & a db pass
 
echo "A database by the name of 'wordpress' was created for you"
echo "Please add a database user: "
read -r -e dbuser
echo "Please add a database password: "
read -r -s dbpass
 
mysql -e "CREATE DATABASE wordpress ;"
mysql -e "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$dbuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"



sudo apt update
#install packages for wordpress

sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
sudo systemctl restart apache2


cat >  /etc/apache2/sites-available/wordpress.conf <<END
 
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
 
END

sudo a2enmod rewrite
 
sudo apache2ctl configtest
 
cd 

#install wordpress
cd /tmp
curl -O https://wordpress.org/latest.tar.gz 
#unzip
tar xzvf latest.tar.gz 
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo find /var/www/html/wordpress/ -type d -exec chmod 750 {} ;
sudo find /var/www/html/wordpress/ -type f -exec chmod 640 {} ; 
curl -s https://api.wordpress.org/secret-key/1.1/salt/
#set WP salts
cd /tmp/wordpress
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php
perl -pi -e "s/database_name_here/wordpress/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
cd