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
- [Update your nginx configuration](https://github.com/voltronic-inverter/web/blob/master/raspberry-pi/nginx.conf#L67-L101) to proxy to the fcgi-interface
- (Optional): Add the [command.html](https://github.com/voltronic-inverter/web/blob/master/shared/command.html) to your nginx static files to allow testing your configuration
