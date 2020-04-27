# Using Ubuntu
apt-get install -y make gcc git autoconf automake libtool pkg-config mingw-w64

## x86

### libserialport
```sh
./autogen.sh
./configure --host=i686-w64-mingw32 --target=xi686-w64-mingw32 --disable-dependency-tracking
make
```

### libhidapi
```sh
./bootstrap
./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
make
```

### libfcgi
```sh
./autogen.sh
./configure --host=i686-w64-mingw32 --target=i686-w64-mingw32
make
```

### fcgi-interface
```sh
rm Makefile
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86 -O Makefile
make
```

## x86-64

### libserialport
```sh
./autogen.sh
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-dependency-tracking
make
```

### libhidapi
```sh
./bootstrap
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
make
```

### libfcgi
```sh
./autogen.sh
./configure --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32
make
```

### fcgi-interface
```sh
rm Makefile
wget https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/Makefile_x86_64 -O Makefile
make
```
