## Ubuntu
apt-get install -y make gcc git autoconf automake libtool pkg-config libudev-dev mingw-w64

### libserialport
```sh
export CC=i686-w64-mingw32-gcc
export CXX=i686-w64-mingw32-c++
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-dependency-tracking
```

###libhidapi
```sh
export CC=i686-w64-mingw32-gcc
export CXX=i686-w64-mingw32-c++
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
```

### libfcgi
```sh
export CC=i686-w64-mingw32-gcc
export CXX=i686-w64-mingw32-c++
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
```

Replace Makefile with one in this repo