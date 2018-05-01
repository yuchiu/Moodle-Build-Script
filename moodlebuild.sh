#!/bin/bash

MOODLEVERSION=''
MYSQLPASSWORD='root'

#install NGINX

yes Y | sudo apt-get install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#install & setup MySQL
#sh /home/yuchiu/Desktop/removemysql.sh
sudo debconf-set-selections <<< 'mysql-server root'
sudo debconf-set-selections <<< 'mysql-server root'  
sudo apt-get -y install mysql-server mysql-client
sudo systemctl start mysql
sudo systemctl enable mysql
####sudo sed -i 's/Basic Settings/Basic Settings\ndefault_storage_engine = innodb\ninnodb_file_per_table = 1\ninnodb_file_format = Barracuda/' /etc/mysql/mysql.conf.d/mysqld.cnf

#Create database and user for Moodle

##sudo mysql -u root -p
##CREATE DATABASE moodledb;
