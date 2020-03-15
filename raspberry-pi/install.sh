#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install the required software
apt-get clean
apt-get update
apt-get install -y gcc git autoconf automake libtool pkg-config libudev-dev libusb-1.0-0-dev nginx spawn-fcgi

# Checkout Fast CGI library
mkdir /opt/voltronic-fcgi-interface
chmod 775 /opt/voltronic-fcgi-interface
git clone https://github.com/voltronic-inverter/fcgi-interface.git /opt/voltronic-fcgi-interface

# Download supporting scripts & configurations
mkdir /opt/voltronic-web
chmod 775 /opt/voltronic-web
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-serial-control -O /opt/voltronic-web/voltronic-fcgi-serial-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-usb-control -O /opt/voltronic-web/voltronic-fcgi-usb-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-control -O /etc/init.d/voltronic-fcgi-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/85-voltronic.rules -O /etc/udev/rules.d/85-voltronic.rules
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/nginx.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/command.html -O /usr/share/nginx/html/command.html

chmod 775 /opt/voltronic-web/voltronic-fcgi-serial-control
chmod 775 /opt/voltronic-web/voltronic-fcgi-usb-control
chmod 775 /etc/init.d/voltronic-fcgi-control
chmod 664 /etc/udev/rules.d/85-voltronic.rules
chmod 664 /etc/nginx/nginx.conf
chmod 664 /usr/share/nginx/html/command.html

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

# FCGI startup scripts
update-rc.d voltronic-fcgi-control defaults

echo "Reboot your Raspberry Pi using 'sudo reboot now'"
