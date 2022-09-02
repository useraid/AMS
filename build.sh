#!/bin/bash

## Build script for AMS

VER="0.1"

export FVER=$VER  # Global Variable for localsrv

mkdir -p ams$VER/DEBIAN

# Creating Control file

touch ams$VER/DEBIAN/control

cat << EOF >> ams$VER/DEBIAN/control
Package: ams
Version: $VER
Section: custom
Priority: optional
Architecture: all
Essential: no
Installed-Size: 1024
Maintainer: github.com/useraid
Description: This program setups a Media server that fetches and installs Movies, Shows, Automatically using various services running as docker containers.
EOF

# Creating postinst

touch ams$VER/DEBIAN/postinst

cat << EOF >> ams$VER/DEBIAN/postinst
chmod +x /usr/local/bin/ams
EOF

# Creating prerm

touch ams$VER/DEBIAN/prerm

cat << EOF >> ams$VER/DEBIAN/prerm
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
EOF

# Creating postrm

touch ams$VER/DEBIAN/postrm

cat << EOF >> ams$VER/DEBIAN/postrm
rm -rf /usr/share/ams
rm /usr/local/bin/ams
EOF

# Program Folder

mkdir -p ams$VER/usr/share/ams

# Adding Main Program

mkdir -p ams$VER/usr/local/bin
cp main.sh ams
chmod +x ams
cp ams ams$VER/usr/local/bin