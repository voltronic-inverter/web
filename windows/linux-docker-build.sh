#!/usr/bin/env bash

echo "$@" | grep -i '\-\-x86\-64' > /dev/null 2>/dev/null 
declare -i IS_X86_64=0
if [ $? -eq 0 ]; then
  declare -i IS_X86_64=1
fi

apt-get clean
apt-get update
TZ='Etc/UTC' DEBIAN_FRONTEND='noninteractive' apt-get install -y tzdata
apt-get install -y make gcc git autoconf automake libtool pkg-config mingw-w64 unzip curl

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

# Build libserialport
cd /src/fcgi-interface/lib/libvoltronic/lib/libserialport
./autogen.sh
if [ $IS_X86_64 -eq 0 ]; then
  ./configure --host=i686-w64-mingw32 --target=xi686-w64-mingw32 --disable-dependency-tracking
else
  ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-dependency-tracking
fi
make

# Build HIDAPI
cd /src/fcgi-interface/lib/libvoltronic/lib/hidapi
./bootstrap
if [ $IS_X86_64 -eq 0 ]; then
  ./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
else
  ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
fi
make

# Build fcgi2
cd /src/fcgi-interface/lib/fcgi2
./autogen.sh
if [ $IS_X86_64 -eq 0 ]; then
  ./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
else
  ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
fi
make

# Build fcgi-interface
cd /src/fcgi-interface
rm -f Makefile
if [ $IS_X86_64 -eq 0 ]; then
  curl -L -o /src/fcgi-interface/Makefile https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86
else
  curl -L -o /src/fcgi-interface/Makefile https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86_64
fi

make clean && make libserialport
if [ $IS_X86_64 -eq 0 ]; then
  mv -f /src/fcgi-interface/libserialport.exe /io/voltronic_fcgi_libserialport_x86.exe
else
  mv -f /src/fcgi-interface/libserialport.exe /io/voltronic_fcgi_libserialport_x86-64.exe
fi

make clean && make hidapi-hidraw
if [ $IS_X86_64 -eq 0 ]; then
  mv -f /src/fcgi-interface/hidapi.exe /io/voltronic_fcgi_hidapi_hidraw_x86.exe
else
  mv -f /src/fcgi-interface/hidapi.exe /io/voltronic_fcgi_hidapi_hidraw_x86-64.exe
fi
