#!/usr/bin/env bash

declare -i IS_X86_64=1
uname -m | grep 'i686' > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  declare -i IS_X86_64=0
fi

# Create directory
mkdir /src

# Get fcgi-interface
cd /src
curl -o /src/temp.zip -L https://github.com/voltronic-inverter/fcgi-interface/archive/master.zip
unzip /src/temp.zip
rm -f /src/temp.zip
mv /src/fcgi-interface-master /src/fcgi-interface
rm -rf /src/fcgi-interface/lib/fcgi2
rm -rf /src/fcgi-interface/lib/libvoltronic

# Get fcgi2
cd /src
curl -o /src/temp.zip -L https://github.com/FastCGI-Archives/fcgi2/archive/master.zip
unzip /src/temp.zip
rm -f /src/temp.zip
mv /src/fcgi2-master /src/fcgi-interface/lib/fcgi2

# Get libvoltronic
cd /src
curl -o /src/temp.zip -L https://github.com/jvandervyver/libvoltronic/archive/master.zip
unzip /src/temp.zip
rm -f /src/temp.zip
mv /src/libvoltronic-master /src/fcgi-interface/lib/libvoltronic
rm -rf /src/fcgi-interface/lib/libvoltronic/lib/hidapi
rm -rf /src/fcgi-interface/lib/libvoltronic/lib/libserialport
rm -rf /src/fcgi-interface/lib/libvoltronic/lib/libusb

# Get libusb
cd /src
curl -o /src/temp.zip -L https://github.com/libusb/libusb/archive/master.zip
unzip /src/temp.zip
rm -f /src/temp.zip
mv /src/libusb-master /src/fcgi-interface/lib/libvoltronic/lib/libusb

# Get HIDAPI
cd /src
curl -o /src/temp.zip -L https://github.com/libusb/hidapi/archive/master.zip
unzip /src/temp.zip
rm -f /src/temp.zip
mv /src/hidapi-master /src/fcgi-interface/lib/libvoltronic/lib/hidapi

# Get libserialport
cd /src
curl -o /src/temp.zip -L 'https://sigrok.org/gitweb/?p=libserialport.git;a=snapshot;h=HEAD;sf=zip'
unzip /src/temp.zip
rm -f /src/temp.zip
mv `ls -1 /src | grep 'libserialport'` /src/fcgi-interface/lib/libvoltronic/lib/libserialport

# Install udev
yum install -y libudev libudev-devel
if [ $IS_X86_64 -eq 0 ]; then
  ln -s /usr/lib/pkgconfig/libudev.pc /hbb_exe/lib/pkgconfig/
else
  ln -s /usr/lib64/pkgconfig/libudev.pc /hbb_exe/lib/pkgconfig/
fi

# Start compiling
source /hbb_exe/activate

# Build fcgi2
cd /src/fcgi-interface/lib/fcgi2
./autogen.sh
./configure
make

# Build libusb
cd /src/fcgi-interface/lib/libvoltronic/lib/libusb/
./autogen.sh
./configure
make
make install
if [ $IS_X86_64 -eq 0 ]; then
  ln -s /usr/local/lib/pkgconfig/libusb-1.0.pc /hbb_exe/lib/pkgconfig/
else
  ln -s /usr/local/lib/pkgconfig/libusb-1.0.pc /hbb_exe/lib/pkgconfig/
fi

# Build HIDAPI
cd /src/fcgi-interface/lib/libvoltronic/lib/hidapi
./bootstrap
./configure
curl -L -o /src/fcgi-interface/lib/libvoltronic/lib/hidapi/hid_extra.h https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/hid_extra.h
sed '/#include "hidapi.h"/a #include "hid_extra.h"' /src/fcgi-interface/lib/libvoltronic/lib/hidapi/linux/hid.c > /src/hid.c
mv -f /src/hid.c /src/fcgi-interface/lib/libvoltronic/lib/hidapi/linux/hid.c
make

# Build libserialport
cd /src/fcgi-interface/lib/libvoltronic/lib/libserialport
./autogen.sh
./configure
make

# Build fcgi-interface
cd /src/fcgi-interface
rm -f Makefile
curl -L -o /src/fcgi-interface/Makefile https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/Makefile

make clean && make libserialport
if [ $IS_X86_64 -eq 0 ]; then
  mv -f /src/fcgi-interface/voltronic_fcgi_libserialport /io/voltronic_fcgi_libserialport_x86
else
  mv -f /src/fcgi-interface/voltronic_fcgi_libserialport /io/voltronic_fcgi_libserialport_x86-64
fi

make clean && make hidapi-hidraw
if [ $IS_X86_64 -eq 0 ]; then
  mv -f /src/fcgi-interface/voltronic_fcgi_hidapi_hidraw /io/voltronic_fcgi_hidapi_hidraw_x86
else
  mv -f /src/fcgi-interface/voltronic_fcgi_hidapi_hidraw /io/voltronic_fcgi_hidapi_hidraw_x86-64
fi
