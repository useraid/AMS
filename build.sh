#!/bin/bash

## Build script for AMS

VER="0.1"

echo $VER

mkdir -p ams/DEBIAN

# Creating Control file

touch ams/DEBIAN/control

cat << EOF >> ams/DEBIAN/control
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

mkdir -p ams/usr/local/bin
cp main.sh ams
cp ams ams/usr/local/bin