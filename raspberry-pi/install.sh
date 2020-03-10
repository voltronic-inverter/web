#!/usr/bin/env bash

if [ "${USER}" != "root" ]; then
  echo "You must be root while executing this script"
  exit 1
fi

# Install the required software
apt-get clean
apt-get update
apt-get install -y gcc git autoconf automake libtool pkg-config libudev-dev libusb-1.0-0-dev nginx spawn-fcgi

# Checkout Fast CGI library
mkdir /opt/voltronic-fcgi-interface
mkdir /opt/voltronic-web
chmod 775 /opt/voltronic-fcgi-interface
chmod 775 /opt/voltronic-web
git clone https://github.com/voltronic-inverter/fcgi-interface.git /opt/voltronic-fcgi-interface
cd /opt/voltronic-fcgi-interface/lib/
./pull_libfcgi2.sh
./pull_libhidapi.sh
./pull_libserialport.sh

# Build fcgi dependency
cd /opt/voltronic-fcgi-interface/lib/libfcgi2
./autogen.sh
./configure
make
make install

# Build HIDApi dependecy
cd /opt/voltronic-fcgi-interface/lib/libhidapi
./bootstrap
./configure
make
make install

# Build libserialport depedency
cd /opt/voltronic-fcgi-interface/lib/libserialport
./autogen.sh
./configure
make
make install

# Build library
cd /opt/voltronic-fcgi-interface/
make serial
make hidraw
make libusb
