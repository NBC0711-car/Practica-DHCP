apt update -y
apt install -y net-tools iproute2 isc-dhcp-client

dhclient -v
ip a