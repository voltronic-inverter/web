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

```
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y
sudo reboot now
```

# Run the install script

```
curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/raspberry-pi/install.sh' | bash
sudo reboot now
```

# Test it

### Using HTML:

Navigate to:
`http://${Raspberry PI IP}:8080/command.html`

# Issue a command directly:

### USB:
```
curl -X POST -d 'QPIGS' 'http://${Raspberry PI IP}:8080/voltronic/usb'
(241.1 50.0 230.1 50.0 0253 0192 005 381 54.60 000 100 0031 0000 000.0 00.00 00000 00010101 00 00 00000 110  # example
```

### Serial:
```
curl -X POST -d 'QPIGS' 'http://${Raspberry PI IP}:8080/voltronic/serial'
(241.1 50.0 230.1 50.0 0253 0192 005 381 54.60 000 100 0031 0000 000.0 00.00 00000 00010101 00 00 00000 110  # example
```

**NOTE**
You likely will have to update /etc/nging/nginx.conf to match your serial port configuration.
`fastcgi_param  SERIAL_PORT_NAME    "/dev/tty.usbserial";`

Change this part `/dev/tty.usbserial` to match your serial port.
