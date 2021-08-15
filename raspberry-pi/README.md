# Introduction

This is a guide to help you setup an HTTP server to communicate with your Axpert inverter.
It takes care of the boring part of communicating with the inverter so you can focus on creating
interesting software using HTML or whatever to actually get the most out of your inverter

This tutorial focuses on getting this communication setup on a Raspberry Pi

# Raspbian

 - Download [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/)
 - Image your SD card with Raspbian Lite
 - Configure the before [Raspberry Pi for headless mode](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) before installing the SD card
 - Start the raspberry pi

# SSH to Raspbian

**SSH to your Raspbian instance**
[Windows](https://mediatemple.net/community/products/dv/204404604/using-ssh-in-putty-)
[Mac](https://osxdaily.com/2017/04/28/howto-ssh-client-mac/)
Linux & FreeBSD should be self explanitory by virtue that your are using POSIX already

# Update your Raspberry Pi

```sh
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y
sudo reboot now
```

# Run the install script

```sh
curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/install.sh' | bash
sudo reboot now
```

# Configure it!

Use your favorite editor to edit the configuration:
```sh
vi /etc/nginx/nginx.conf
vim /etc/nginx/nginx.conf
nano /etc/nginx/nginx.conf
# etc...
```

To configure serial, [modify the parameters in the serial section](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L79-L83)

To configure USB, [modify the parameters in the USB section](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L101-L102)

In both cases you can uncomment a configuration be removing the #

And simply change the current value with what suits you

**You likely will have to update /etc/nging/nginx.conf to match your serial port configuration.**

`fastcgi_param  SERIAL_PORT_NAME    "/dev/tty.usbserial";`

Change this part `/dev/tty.usbserial` to match your serial port.

# Test it

### Using HTML:

Navigate to: `http://${Raspberry PI IP}:8080/command.html`

# Issue a command directly:

### USB
```sh
curl -X POST -d 'QPIGS' 'http://${Raspberry PI IP}:8080/voltronic/usb'
(241.1 50.0 230.1 50.0 0253 0192 005 381 54.60 000 100 0031 0000 000.0 00.00 00000 00010101 00 00 00000 110  # example
```

### Serial
```sh
curl -X POST -d 'QPIGS' 'http://${Raspberry PI IP}:8080/voltronic/serial'
(241.1 50.0 230.1 50.0 0253 0192 005 381 54.60 000 100 0031 0000 000.0 00.00 00000 00010101 00 00 00000 110  # example
```

# FAQ

### Why do I keep getting (NAK

`(NAK` means the inverter could not process the command.  There are a number of possible reasons:
- The inverter does not support the command you are sending it
- The inverter (for example, some Infini solar models) [does not accept CRC on input, disable that here](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L76).  Make sure to modify that in USB also!
- The inverter has some kind of protocol completely unknown to the library (unlikely, but contact me and we can take a look)

### Why FastCGI?

Fast CGI is still widely used and almost every single web-server supports it.  Rather than roll my own web-server or tie my implementation to a specific web-server I used FastCGI which opens a lot of doors.

It is also very lightweight and fast and allows me to focus on solving the problem (communicating with the inverter) rather than creating a standard complaint web-server

### Why is this written in C?

I wrote a library in both Ruby & Java also.  To communicate over serial and USB HID requires operating system integration.  C was the only langauge that had a mature solution for both and provided very low latency.

Got close using Java by using JNA that created a highly portable library but it was still around 100ms slower for serial port and this was just simpler

### What will this run on?

I've tested this on OSX, Linux (Ubuntu), Raspbian (Wheezy & Buster), Venus OS, Windows XP, Windows 7, Windows 10 and FreeBSD.  Adding support to more obscure operating systems like the other variants of BSD or Solaris should be trivial.
