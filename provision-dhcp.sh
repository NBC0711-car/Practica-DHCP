#!/bin/bash

sudo apt update
sudo apt install -y isc-dhcp-server net-tools iproute2
sudo cp /etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf.bak
sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server --no-pager

