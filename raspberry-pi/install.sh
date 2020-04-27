#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install the required software
apt-get clean
apt-get update
apt-get install -y nginx spawn-fcgi

# Create directory for binaries
mkdir /opt/voltronic-fcgi-interface
chmod 775 /opt/voltronic-fcgi-interface

# Download udev rules
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/35-voltronic-udev.rules -O /etc/udev/rules.d/35-voltronic-udev.rules
chmod 664 /etc/udev/rules.d/35-voltronic-udev.rules

# Download CGI interface binaries
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/binary/wheezy/voltronic_fcgi_hidapi_hidraw -O /opt/voltronic-fcgi-interface/voltronic_fcgi_hidapi_hidraw
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/binary/wheezy/voltronic_fcgi_libserialport -O /opt/voltronic-fcgi-interface/voltronic_fcgi_libserialport
chmod 775 /opt/voltronic-fcgi-interface/voltronic_fcgi_hidapi_hidraw
chmod 775 /opt/voltronic-fcgi-interface/voltronic_fcgi_libserialport

# Download CFG interface control scripts
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-serial-control -O /opt/voltronic-fcgi-interface/voltronic-fcgi-serial-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-usb-control -O /opt/voltronic-fcgi-interface/voltronic-fcgi-usb-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-control -O /etc/init.d/voltronic-fcgi-control
chmod 775 /opt/voltronic-fcgi-interface/voltronic-fcgi-serial-control
chmod 775 /opt/voltronic-fcgi-interface/voltronic-fcgi-usb-control
chmod 775 /etc/init.d/voltronic-fcgi-control

# Download nginx configuration & sample web-page
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/nginx.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/command.html -O /usr/share/nginx/html/command.html
chmod 664 /etc/nginx/nginx.conf
chmod 664 /usr/share/nginx/html/command.html

# FCGI startup scripts
update-rc.d voltronic-fcgi-control defaults

echo "Reboot your Raspberry Pi using 'sudo reboot now'"
