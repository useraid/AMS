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

# Program Folder

mkdir -p ams$VER/usr/share/ams

# Adding Main Program

mkdir -p ams$VER/usr/local/bin
cp main.sh ams
chmod +x ams
cp ams ams$VER/usr/local/bin