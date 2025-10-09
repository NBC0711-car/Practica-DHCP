# -*- mode: ruby -*-
# vi: set ft=ruby :

# 1. Start the main configuration block, using 'config' as the object handle.
Vagrant.configure("2") do |config|
  
  # 2. Use the 'config' variable (not Vagrant.configure) for all settings
  # Set the base box for all VMs
  config.vm.box = "debian/bullseye64" # Using a known, safe box

  # --- DHCP Server ('practice' machine) ---
  config.vm.define "practice" do |practice|
      
      # Use the machine's local variable ('practice') to set its properties
      practice.vm.hostname = "DHCPractice"
      
      # Adapter 1: 192.168.56.0/24 (Host-only, static IP for management)
      practice.vm.network "private_network", ip: "192.168.56.10"
      
      # Adapter 2: 192.168.57.0/24 (Internal, DHCP service runs here)
      practice.vm.network "private_network", ip: "192.168.57.10", virtualbox__intnet: "dhcp-internal"
      
      # Provisioning script to install the DHCP service
      practice.vm.provision "shell", path: "provision-dhcp.sh"  
  end
  
  # --- Client 1 (c1) - Dynamic IP ---
  config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1" 
    
    # Connects to the "dhcp-internal" network and requests IP via DHCP.
    c1.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
  end
  
  # --- Client 2 (c2) - Fixed IP Reservation ---
  config.vm.define "c2" do |c2|
    c2.vm.hostname = "c2"
    
    # Connects to the "dhcp-internal" network and requests IP via DHCP.
    c2.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
    
    # REQUIRED: MAC address for the DHCP server to assign the fixed IP (192.168.57.4)
    c2.vm.base_mac = "080027112233" 
  end
  
end # 3. This 'end' closes the main Vagrant.configure block