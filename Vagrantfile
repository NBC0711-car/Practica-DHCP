# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/debian"
  config.vm.provider = "virtualbox" do |vm| 
  end
  config.vm.define "DHCPractice" do |DHCPractice|
      DHCPractice.hostname = "DHCPractice"
      DHCPractice.vm.network "private network", ip: "192.168.56.10" # This is for host-to-server communication static IP (the host can access at the server with this address)
      DHCPractice.vm.network "private network", ip: "192.168.57.10", virtualbox__intnet: "dhcp-internal" #This is where the DHCP service will run, static IP to the server interface
      DHCPractice.vm.provision "shell", Path: "provision-dhcp.sh"  
  end
  config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1" #the adapter 1 will be the one that comes by default for outbound.
    c1.vm.network "private_network" type: "dhcp"  #The adapter 2 will connect to the dhcp-internal network, if we ommit the ip parameter vagrant will set the network adapter to use DHCP
  end
  config.v,.define "c2" do |c2|
    c2.vm.hostname = "c2"
    c2.vm.network "private_network" type: "dhcp" # IMPORTANT: The MAC address must be specified for 'c2' so the DHCP server can recognize it and assign the fixed IP (192.168.57.4)
    c2.vm.base_mac = "080027112233" #Use this value in dhcp.conf 
  end
end
