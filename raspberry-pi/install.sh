#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install the required software
apt-get clean
apt-get update
apt-get install -y nginx spawn-fcgi

# Create directory for binaries
mkdir /opt/voltronic-web
chmod 775 /opt/voltronic-web

# Download udev rules for voltronic inverter USB device
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/shared/35-voltronic-udev.rules -O /etc/udev/rules.d/35-voltronic-udev.rules
chmod 664 /etc/udev/rules.d/35-voltronic-udev.rules

# Download CGI interface binaries
wget https://raw.githubusercontent.com/voltronic-inverter/binaries/master/1.0.0/linux/voltronic_fcgi_serial_armv6 -O /opt/voltronic-web/voltronic_fcgi_serial
wget https://raw.githubusercontent.com/voltronic-inverter/binaries/master/1.0.0/linux/voltronic_fcgi_usb_armv6 -O /opt/voltronic-web/voltronic_fcgi_usb
chmod 775 /opt/voltronic-web/voltronic_fcgi_serial
chmod 775 /opt/voltronic-web/voltronic_fcgi_usb

# Download CFG interface control scripts
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-serial-control -O /opt/voltronic-web/voltronic-fcgi-serial-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-usb-control -O /opt/voltronic-web/voltronic-fcgi-usb-control
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/voltronic-fcgi-control -O /etc/init.d/voltronic-fcgi-control
chmod 775 /opt/voltronic-web/voltronic-fcgi-serial-control
chmod 775 /opt/voltronic-web/voltronic-fcgi-usb-control
chmod 775 /etc/init.d/voltronic-fcgi-control

# Download nginx configuration & sample web-page
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/nginx.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/shared/command.html -O /usr/share/nginx/html/command.html
chmod 664 /etc/nginx/nginx.conf
chmod 664 /usr/share/nginx/html/command.html

# FCGI startup scripts
update-rc.d voltronic-fcgi-control defaults

echo "Reboot your Raspberry Pi using 'sudo reboot now'"
