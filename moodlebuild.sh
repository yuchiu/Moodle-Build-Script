
#!/bin/bash

MOODLEVERSION=''

#install NGINX

sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#install & setup MySQL
sudo apt-get -y install mysql-server mysql-client

#sudo apt-get -y install mysql-server mysql-client

sudo systemctl start mysql
sudo systemctl enable mysql
####sudo sed -i 's/Basic Settings/Basic Settings\ndefault_storage_engine = innodb\ninnodb_file_per_table = 1\ninnodb_file_format = Barracuda/' /etc/mysql/mysql.conf.d/mysqld.cnf

#Create database and user for Moodle

sudo mysql -u root -proot -Bse "CREATE DATABASE moodledb;ALTER DATABASE moodledb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;FLUSH PRIVILEGES;CREATE USER moodleuser@localhost IDENTIFIED BY moodlepassword;GRANT ALL ON moodledb.* TO moodleuser@localhost;FLUSH PRIVILEGES;EXIT;"

sudo apt-get -y install php7.0-fpm graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring
