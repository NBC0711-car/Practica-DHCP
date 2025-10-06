# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/debian"
  config.vm.provider = "virtualbox" do |vm|
  end
  config.vm.define "DHCPractice" do |DHCPractice|
      DHCPractice.hostname = "DHCPractice"
      DHCPractice.vm.network "private network", ip: "192.168.56.21"
      DHCPractice.vm.network "private network", ip: "192.168.57.21", virtualbox__intnet: "dhcp-internal"
      DHCPractice.vm.provision "shell", Path: "provision-dhcp.sh"  
  end
end
