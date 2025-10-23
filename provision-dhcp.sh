#!/bin/bash
set -e
apt-get update
apt-get install -y isc-dhcp-server
cat > /etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 3600;
max-lease-time 7200;
authoritative;
subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.100 192.168.57.200;
  option routers 192.168.57.21;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 8.8.8.8 1.1.1.1;
  option domain-name "micasa.local";
  default-lease-time 3600;
  max-lease-time 7200;
}
host c2 {
  hardware ethernet 08:00:27:11:22:33;
  fixed-address 192.168.57.4;
}
EOF
systemctl enable isc-dhcp-server
systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server --no-pager
