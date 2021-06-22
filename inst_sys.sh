#!/bin/bash

echo "Updating packages..."
apt update
apt upgrade

echo "Installing dependencies..."
apt -y install apt-transport-https lsb-release ca-certificates curl unzip unclutter beep

echo "Installing XServer..."
apt -y install xserver-xorg-video-all xserver-xorg-input-all xserver-xorg-core xinit x11-xserver-utils

echo "Configuring XServer..."
wget -O /home/kiosk-user/.xinitrc https://raw.githubusercontent.com/KioskPEM/CactusInstall/master/.xinitrc
chown kiosk-user /home/kiosk-user/.xinitrc
echo "startx"> /home/kiosk-user/.bash_profile

echo "Installing Chromium..."
apt -y install chromium

echo "Installing Nginx..."
apt -y install nginx

echo "Configuring Nginx..."
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
wget -O /etc/nginx/sites-available/cactus.conf https://raw.githubusercontent.com/KioskPEM/CactusInstall/master/cactus.conf
ln -s /etc/nginx/sites-available/cactus.conf /etc/nginx/sites-enabled/
service nginx reload

echo "Installing PHP..."
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update
apt -y install php-fpm php-curl php-zip php-mbstring

echo "Downloading Cactus..."
wget -O /home/kiosk-user/master.zip https://github.com/KioskPEM/Cactus/archive/master.zip

echo "Decompressing Cactus..."
unzip /home/kiosk-user/master.zip -d /home/kiosk-user

echo "Installing Cactus..."
mv /home/kiosk-user/Cactus-master /home/kiosk-user/public_html
chown -R kiosk-user:www-data /home/kiosk-user/public_html
chmod -R g+rw /home/kiosk-user/public_html
rm /home/kiosk-user/master.zip

echo "Configuring auto login..."
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]" > /etc/systemd/system/getty@tty1.service.d/override.conf
echo "ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo "ExecStart=-/sbin/agetty --autologin kiosk-user --noclear %I 38400 linux" >> /etc/systemd/system/getty@tty1.service.d/override.conf

echo "Configuring permission..."
usermod www-data -a -G dialout
addgroup --system beep
usermod www-data -a -G beep
echo "ACTION==\"add\", SUBSYSTEM==\"input\", ATTRS{name}==\"PC Speaker\", ENV{DEVNAME}!=\"\", RUN+=\"/usr/bin/setfacl -m g:beep:w '\$env{DEVNAME}'\""> /etc/udev/rules.d/90-pcspkr-beep.rules
modprobe -r pcspkr
sleep 2
modprobe pcspkr

echo "Downloading additional scripts..."
wget -O /home/kiosk-user/inst_ts.sh https://raw.githubusercontent.com/KioskPEM/CactusInstall/master/inst_ts.sh

echo "Done."
