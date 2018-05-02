
#!/bin/bash



MOODLEVERSION='MOODLE_33_STABLE'

#
# 1. install NGINX
#

sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#
# 2. install & setup MySQL
#

sudo apt-get -y install mysql-server mysql-client
sudo systemctl start mysql
sudo systemctl enable mysql
sudo sed -i 's/Basic Settings/Basic Settings\ndefault_storage_engine = innodb\ninnodb_file_per_table = 1\ninnodb_file_format = Barracuda/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo mysql -u root -proot -Bse "create database moodle default character set utf8;"

#
# 3. Install PHP & Moodle's dependencies
#
sudo apt-get -y install php7.0-fpm graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/cli/php.ini
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

#
# 4. Download Moodle
#

sudo apt-get install git
cd /var/www/html
sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch -a
sudo git branch --track $MOODLEVERSION origin/$MOODLEVERSION
sudo git checkout $MOODLEVERSION
sudo mkdir -p /var/www/html/moodledata
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

#
# 5. Config NGINX
#

sudo echo "#NGINX Config" | sudo tee /etc/nginx/sites-available/moodle
sudo sed -i 's@#NGINX Config@#NGINX Config\nserver\n{\nlisten 80 default_server;\nlisten [::]:80 default_server;\nroot /var/www/html/moodle;\nrewrite ^/(.*\.php)(/)(.*)$ /$1?file=/$3 last;\nindex index.php index.html index.htm index.nginx-debian.html;\nserver_name _;\nlocation / {\ntry_files $uri $uri/ /index.php?q=$request_uri;\n}\nlocation ~ \.php$ {\ninclude snippets/fastcgi-php.conf;\nfastcgi_pass unix:/var/run/php/php7.0-fpm.sock;\n}\n}\n@' /etc/nginx/sites-available/moodle
sudo ln -s /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
