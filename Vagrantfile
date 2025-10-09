# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/debian"
  config.vm.define "practice" do |practice|
      practice.vm.hostname = "DHCPractice"
      practice.vm.network "private_network", ip: "192.168.56.10" # This is for host-to-server communication static IP (the host can access at the server with this address)
      practice.vm.network "private_network", ip: "192.168.57.10", virtualbox__intnet: "dhcp-internal" #This is where the DHCP service will run, static IP to the server interface
      practice.vm.provision "shell", path: "provision-dhcp.sh"  
  end
  Vagrant.config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1" #the adapter 1 will be the one that comes by default for outbound.
    c1.vm.network "private_network", type: "dhcp"  #The adapter 2 will connect to the dhcp-internal network, if we ommit the ip parameter vagrant will set the network adapter to use DHCP
  end
  Vagrant.config.vm.define "c2" do |c2|
    c2.vm.hostname = "c2"
    c2.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal" # IMPORTANT: The MAC address must be specified for 'c2' so the DHCP server can recognize it and assign the fixed IP (192.168.57.4)
    c2.vm.base_mac = "080027112233" #Use this value in dhcp.conf 
  end
end
