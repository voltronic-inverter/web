#!/usr/bin/env bash

# Fetch all the repos
curl -L -o '/src/repo_fetcher.sh' 'https://raw.githubusercontent.com/voltronic-inverter/web/master/shared/repo_fetcher.sh'
chmod 775 '/src/repo_fetcher.sh'
/src/repo_fetcher.sh

# Determine target platform
uname -m | grep 'i686' > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  echo 'Building i686 Linux binaries'
  declare -i IS_X86_64=0
else
  declare -i IS_X86_64=1
  echo 'Building x86-64 Linux binaries'
fi

# Install udev; We will not be linking to it statically
yum install -y libudev libudev-devel
if [ $IS_X86_64 -eq 0 ]; then
  ln -s /usr/lib/pkgconfig/libudev.pc /hbb_exe/lib/pkgconfig/
else
  ln -s /usr/lib64/pkgconfig/libudev.pc /hbb_exe/lib/pkgconfig/
fi

# Start compiling
source /hbb_exe/activate

# Build fcgi2
cd /build/fcgi-interface/lib/fcgi2
./autogen.sh
./configure
make

# Build libserialport
cd /build/fcgi-interface/lib/libvoltronic/lib/libserialport
./autogen.sh
./configure
make

# Build libusb
cd /build/fcgi-interface/lib/libvoltronic/lib/libusb/
./autogen.sh
./configure
make
make install
if [ $IS_X86_64 -eq 0 ]; then
  ln -s /usr/local/lib/pkgconfig/libusb-1.0.pc /hbb_exe/lib/pkgconfig/
else
  ln -s /usr/local/lib/pkgconfig/libusb-1.0.pc /hbb_exe/lib/pkgconfig/
fi

# Build HID API
cd /build/fcgi-interface/lib/libvoltronic/lib/hidapi
./bootstrap
./configure

# Required because of possible missing defines for HID
curl -L -o /build/fcgi-interface/lib/libvoltronic/lib/hidapi/hid_extra.h 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/hid_extra.h'
sed '/#include "hidapi.h"/a #include "hid_extra.h"' /build/fcgi-interface/lib/libvoltronic/lib/hidapi/linux/hid.c > /tmp/hid.c
mv -f '/tmp/hid.c' '/build/fcgi-interface/lib/libvoltronic/lib/hidapi/linux/hid.c'

make

# Build fcgi-interface
cd /build/fcgi-interface
rm -f Makefile
curl -L -o '/build/fcgi-interface/Makefile' 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/Makefile'

make clean && make libserialport
if [ $IS_X86_64 -eq 0 ]; then
  mv -f '/build/fcgi-interface/voltronic_fcgi_libserialport' '/io/voltronic_fcgi_libserialport_i686'
else
  mv -f '/build/fcgi-interface/voltronic_fcgi_libserialport' '/io/voltronic_fcgi_libserialport_x86-64'
fi

make clean && make hidapi-hidraw
if [ $IS_X86_64 -eq 0 ]; then
  mv -f '/build/fcgi-interface/voltronic_fcgi_hidapi_hidraw' '/io/voltronic_fcgi_hidapi_hidraw_i686'
else
  mv -f '/build/fcgi-interface/voltronic_fcgi_hidapi_hidraw' '/io/voltronic_fcgi_hidapi_hidraw_x86-64'
fi
