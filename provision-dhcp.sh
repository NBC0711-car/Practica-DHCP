#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Starting Robust DHCP Server Provisioning ---"

# 1. Install ISC DHCP Server
sudo apt update
sudo apt install -y isc-dhcp-server

# 2. Identify the correct interface for the 192.168.57.10 IP
# The interface with the second private network IP (192.168.57.10) is the one we need.
# We look for the interface that has the IP 192.168.57.10 assigned by Vagrant.
DHCP_IFACE=$(ip -o addr show | awk '/192.168.57.10/ {print $2}')

if [ -z "$DHCP_IFACE" ]; then
    echo "ERROR: Could not automatically detect the DHCP interface (192.168.57.10)."
    # Fallback to a common name if not found
    DHCP_IFACE="enp0s8"
fi

echo "Detected DHCP Interface: $DHCP_IFACE"

# 3. Configure DHCP server to listen on the correct interface
# This tells the service which interface to monitor for DHCP requests.
echo "INTERFACESv4=\"$DHCP_IFACE\"" | sudo tee /etc/default/isc-dhcp-server

# 4. Create a minimal valid dhcpd.conf to allow the service to start
# The service MUST have a valid configuration file before it attempts to start.
sudo tee /etc/dhcp/dhcpd.conf > /dev/null <<-EOF
# Minimal configuration to allow the DHCP service to start
# The full configuration for the range and fixed IP will be added later.
default-lease-time 600;
max-lease-time 7200;
log-facility local7;

subnet 192.168.57.0 netmask 255.255.255.0 {
    range 192.168.57.100 192.168.57.200;
    option routers 192.168.57.10;
    option subnet-mask 255.255.255.0;
}
EOF

# 5. Restart the network to ensure the static IP is fully configured (less critical, but safe)
# In case the network wasn't fully up when the script started.
# On Debian/Ubuntu, netplan or networking service is used. We use ifdown/ifup for the specific interface.
sudo ifdown $DHCP_IFACE || true
sudo ifup $DHCP_IFACE || true

# 6. Attempt to restart the service again (this time with the interface and config defined)
echo "Attempting to restart isc-dhcp-server..."
sudo systemctl daemon-reload
sudo systemctl restart isc-dhcp-server
sudo systemctl status isc-dhcp-server --no-pager | head -n 5

echo "--- DHCP Server Provisioning Complete. Check status above. ---"