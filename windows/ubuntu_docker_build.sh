#!/usr/bin/env bash

# Install the required dependencies
TZ='Etc/UTC' DEBIAN_FRONTEND='noninteractive' apt-get install -y tzdata
apt-get install -y make gcc git autoconf automake libtool pkg-config mingw-w64 unzip curl

# Get repo fetching script
mkdir '/src/'
curl -L -o '/src/repo_fetcher.sh' 'https://raw.githubusercontent.com/voltronic-inverter/web/master/shared/repo_fetcher.sh'
chmod 775 '/src/repo_fetcher.sh'
/src/repo_fetcher.sh

echo "Starting build loop"

# Start the build loop
x=1
IS_X86_64=0
while [ $count -le 1 ]; do
  IS_X86_64=$(( $IS_X86_64 + 1 ))

  rm -rf '/build' 1>/dev/null 2>/dev/null

  if [ $IS_X86_64 -eq 1 ]; then
    echo "Building i686 binaries"
  elif [ $IS_X86_64 -eq 2 ]; then
    echo "Building x86-64 binaries"
  else
    echo "Unsupported build mode"
    exit 1
  fi
  /src/repo_fetcher.sh

  # Build libserialport
  cd '/build/fcgi-interface/lib/libvoltronic/lib/libserialport'
  ./autogen.sh
  if [ $IS_X86_64 -eq 1 ]; then
    ./configure --host=i686-w64-mingw32 --target=xi686-w64-mingw32 --disable-dependency-tracking
  else
    ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-dependency-tracking
  fi
  make

  # Build HIDAPI
  cd '/build/fcgi-interface/lib/libvoltronic/lib/hidapi'
  ./bootstrap
  if [ $IS_X86_64 -eq 1 ]; then
    ./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
  else
    ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
  fi
  make

  # Build fcgi2
  cd '/build/fcgi-interface/lib/fcgi2'
  ./autogen.sh
  if [ $IS_X86_64 -eq 1 ]; then
    ./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
  else
    ./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
  fi
  make

  # Build fcgi-interface
  cd '/build/fcgi-interface'
  rm -f Makefile
  if [ $IS_X86_64 -eq 1 ]; then
    curl -L -o '/build/fcgi-interface/Makefile' 'https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86'
  else
    curl -L -o '/build/fcgi-interface/Makefile' 'https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86_64'
  fi

  make clean && make libserialport
  if [ $IS_X86_64 -eq 1 ]; then
    mv -f '/build/fcgi-interface/libserialport.exe' '/io/voltronic_fcgi_libserialport_i686.exe'
  else
    mv -f '/src/fcgi-interface/libserialport.exe' '/io/voltronic_fcgi_libserialport_x86-64.exe'
  fi

  make clean && make hidapi
  if [ $IS_X86_64 -eq 1 ]; then
    mv -f '/src/fcgi-interface/hidapi.exe' '/io/voltronic_fcgi_hidapi_hidraw_i686.exe'
  else
    mv -f '/src/fcgi-interface/hidapi.exe' '/io/voltronic_fcgi_hidapi_hidraw_x86-64.exe'
  fi

  x=$(( $x + 1 ))
done

echo "Build complete"
