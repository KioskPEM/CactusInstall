#!/bin/bash

echo "Downloading driver..."
wget -O /tmp/elo_driver.tar http://assets.ctfassets.net/of6pv6scuh5x/1OlYcxrAW8QOU4Ycugegkw/93d4d5c18a771f281c3847cb12fb1410/SW602362_Elo_Linux_Serial_Driver_v3.4.0_i686.tar

echo "Extracting driver..."
tar xvf /tmp/elo_driver.tar -C /tmp/
cp -r /tmp/bin-serial/ /etc/opt/elo-ser
chmod -R 777 /etc/opt/elo-ser/*
chmod -R 444 /etc/opt/elo-ser/*.txt

echo "Configuring driver..."
echo "Enter the serial port in which the touchscreen is plugged in:"
read serialPort

echo "Creating service..."
echo "[Service]" > /etc/systemd/system/elotouch.service
echo "Type=oneshot" >> /etc/systemd/system/elotouch.service
echo "RemainAfterExit=yes" >> /etc/systemd/system/elotouch.service
echo "ExecStart=/etc/opt/elo-ser/setup/loadelo" >> /etc/systemd/system/elotouch.service
echo "ExecStart=/etc/opt/elo-ser/eloser $serialPort" >> /etc/systemd/system/elotouch.service
echo "" >> /etc/systemd/system/elotouch.service
echo "[Install]" >> /etc/systemd/system/elotouch.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/elotouch.service
systemctl enable elotouch

echo "Starting service..."
systemctl start elotouch
