## What is in this repo?

A collection of information, scripts and/or anything related to getting [voltronic-inverter/fcgi-interface](https://github.com/voltronic-inverter/fcgi-interface) working on various operating systems

Each directory contains a README.md, like this one, detailing the installation procedure for the given operating system/platform

## Operating systems not listed here

[voltronic-inverter/fcgi-interface](https://github.com/voltronic-inverter/fcgi-interface) operates exactly the same regardless of operating system.

In short, the recommended approach is:
- Install nginx for your operating system
- Get [voltronic-inverter/fcgi-interface](https://github.com/voltronic-inverter/fcgi-interface) from
  - [Binaries](https://github.com/voltronic-inverter/binaries)
  - OR compile it yourself if your operating system is not supplied in binary form
- [Update your nginx configuration](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L67-L106) to proxy to the fcgi-interface
- (Optional): Add the [command.html](https://github.com/voltronic-inverter/web/blob/master/shared/command.html) to your nginx static files to allow testing your configuration

# FAQ

### Why do I keep getting (NAK

`(NAK` means the inverter could not process the command.  There are a number of possible reasons:
- The inverter does not support the command you are sending it
- The inverter (for example, some Infini solar models) [does not accept CRC on input, disable that like the example here](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L76).  Make sure to modify that in USB also!
- The inverter has some kind of protocol completely unknown to the library (unlikely, but contact me and we can take a look)

### Why FastCGI?

Fast CGI is still widely used and almost every single web-server supports it.  Rather than roll my own web-server or tie my implementation to a specific web-server I used FastCGI which opens a lot of doors.

It is also very lightweight and fast and allows me to focus on solving the problem (communicating with the inverter) rather than creating a standard complaint web-server

### Why is this written in C?

I wrote a library in both Ruby & Java also.  To communicate over serial and USB HID requires operating system integration.  C was the only langauge that had a mature solution for both and provided very low latency.

Got close using Java by using JNA that created a highly portable library but it was still around 100ms slower for serial port and this was just simpler

### What will this run on?

I've tested this on OSX, Linux (Ubuntu), Raspbian (Wheezy & Buster), Venus OS, Windows XP, Windows 7, Windows 10 and FreeBSD.  Adding support to more obscure operating systems like the other variants of BSD or Solaris should be trivial.
