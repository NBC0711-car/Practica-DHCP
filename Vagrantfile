# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

  config.vm.define "practice" do |practice|
      practice.vm.hostname = "DHCPractice"
      practice.vm.network "private_network", ip: "192.168.56.10"
      practice.vm.network "private_network", ip: "192.168.57.10", virtualbox__intnet: "dhcp-internal"
      
      practice.vm.provision "shell", path: "provision-dhcp.sh"  
  end #end practice
  
  config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1" 
    
    c1.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
  end # end c1
  
  config.vm.define "c2" do |c2|
    c2.vm.hostname = "c2"
    c2.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
    c2.vm.base_mac = "080027112233" 
  end # end c2
end # end configuration