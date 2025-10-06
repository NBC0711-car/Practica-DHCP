
      sudo apt update
      # Install the ISC DHCP server package
      sudo apt install -y isc-dhcp-server

      # Restart the DHCP service to apply changes
      sudo systemctl restart isc-dhcp-server