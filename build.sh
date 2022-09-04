#!/bin/bash

## Build script for AMS

VER="0.1.4"

export FVER=$VER  # Global Variable for localsrv

mkdir -p ams$VER/DEBIAN

# Creating Control file

touch ams$VER/DEBIAN/control

cat << EOF > ams$VER/DEBIAN/control
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
mv ams ams$VER/usr/local/bin

# Setting permissions

chmod 755 ams$VER/DEBIAN/postrm

# Building it

dpkg-deb --build ams$VER