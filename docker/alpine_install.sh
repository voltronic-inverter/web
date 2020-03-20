#!/usr/bin/env sh

apk add --no-cache gcc musl-dev git autoconf make automake libtool libusb-dev eudev-dev linux-headers spawn-fcgi

git clone https://github.com/voltronic-inverter/fcgi-interface.git /opt/voltronic-fcgi-interface
cd /opt/voltronic-fcgi-interface/lib
./pull_libhidapi.sh
./pull_libserialport.sh
./pull_libfcgi2.sh

cd /opt/voltronic-fcgi-interface/lib/libhidapi/
./bootstrap
./configure --disable-dependency-tracking
make
make install

cd /opt/voltronic-fcgi-interface/lib/libserialport/
./autogen.sh
./configure
make
make install

cd /opt/voltronic-fcgi-interface/lib/libfcgi2/
./autogen.sh
./configure
make
make install

cd /opt/voltronic-fcgi-interface
make serial
make hidraw
make libusb
