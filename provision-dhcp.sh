#!/bin/bash

sudo apt update
sudo apt install -y isc-dhcp-server
sudo systemctl restart isc-dhcp-server
sudo cp /etc/dhcp/dhclient.conf /home/alumnom/vagrant/shared/dhclient.conf
