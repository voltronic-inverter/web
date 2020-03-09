# Introduction

This is a guide to help you setup an HTTP server to communicate with your Axpert inverter.
It takes care of the boring part of communicating with the inverter so you can focus on creating
interesting software using HTML or whatever to actually get the most out of your inverter

This tutorial focuses on getting this communication setup on a Raspberry Pi

# Raspbian

 - Download [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/)
 - Image your SD card with Raspbian Lite
 - [Enable SSH access](https://www.raspberrypi.org/documentation/remote-access/ssh/)
 - Start your Raspberry Pi with the new image
 - Connect it to your **local** network

# SSH to Raspbian

SSH to your Raspbian instance
- Posix (*NIX/*BSD/OSX): Use the ssh command on your terminal
- Windows: [I recommend using PuTTY](https://mediatemple.net/community/products/dv/204404604/using-ssh-in-putty-)

# Install nginx (pronounced engine X)

[Follow the guide here to install nginx](https://www.raspberrypi.org/documentation/remote-access/web-server/nginx.md)

### NOTE
Only install nginx, do not do any of the PHP install or configuration.  Unless you plan is to use PHP of course 🤮

# Install the required libraries

# Checkout Fast CGI Voltronic interface using git

# Build the library

# Configure nginx to use the library

# Test it
