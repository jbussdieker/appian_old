# Build Box

NOTE: Jenkins gave me issues with not saving the git url on Jenkins GIT plugin 1.1.15. Upgrade to 1.1.21 fixed it.

 # Install jenkins
 sudo apt-get update
 sudo apt-get install jenkins
 sudo su jenkins
 ssh-keygen
 
 # Install git
 sudo apt-get install git
 
 # Install build tools
 sudo apt-get install make
 sudo apt-get install gcc
 
 # Install ruby 1.9.2-p180
 wget https://s3.amazonaws.com/appian/rvm-ruby-1.9.2-p180.tar
 tar -zxvf rvm-ruby-1.9.2-p180.tar
 sudo mv rvm /usr/local

 # Install ruby 1.9.2-p180 scratch
 curl -L https://get.rvm.io | sudo bash -s stable
 rvm pkg install openssl
 rvm install 1.9.2-p180 --with-openssl-dir=$rvm_path/usr
 tar -zcvf rvm-ruby-1.9.2-p180.tar /usr/local/rvm

 # For rails
 sudo apt-get install nodejs
 
 # For rails tests
 sudo apt-get install sqlite3
 sudo apt-get install libsqlite3-dev
 
 # Create a jenkins container and env
 source /usr/local/rvm/scripts/rvm
 rvm use 1.9.2-p180
 rvmsudo rvm gemset create jenkins
 sudo chown -R jenkins:jenkins /usr/local/rvm/gems/ruby-1.9.2-p180@jenkins
 
 # Install go
 sudo apt-get install mercurial
 sudo apt-get install bison
 wget https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer
 sudo bash gvm-installer master /usr/local
 source /usr/local/gvm/scripts/gvm

# App Server

* Needs most of the build box config depending on necessary envs

Apache2 Config in sites-available/#{site_name}

 <VirtualHost *:8080>
    ServerName phone.jbussdieker.com
    ServerAlias phone.jbussdieker.name
    # !!! Be sure to point DocumentRoot to 'public'!
    DocumentRoot /srv/phone/public
    <Directory /srv/phone/public>
       # This relaxes Apache security settings.
       AllowOverride all
       # MultiViews must be turned off.
       Options -MultiViews
    </Directory>
 </VirtualHost>

Nginx Config in sites-available/#{site_name}

 upstream www.domain.com {
   server 127.0.0.1:8080;
 }
 
 server {
   listen 80;
   server_name www.domain.com;
   location / {
     proxy_pass http://www.domain.com;
   }
 }

