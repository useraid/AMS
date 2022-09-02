#!/bin/bash

# Installing Apache Webserver

sudo apt-get -y install apache2
sudo mkdir /var/www/html/debian
sudo cp ams$FVER.deb /var/www/html/debian/

# Creating Package list

dpkg-scanpackages /var/www/html/debian/ | gzip -c9  > /var/www/html/debian/Packages.gz

# Adding to sources.list

echo "deb [trusted=yes] http://$(hostname -I | cut -d' ' -f1)/debian ./" | tee -a /etc/apt/sources.list > /dev/null