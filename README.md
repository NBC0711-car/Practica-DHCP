This practice sets up a virtual environment to configure a DHCP server using Vagrant and VirtualBox.
Vagrant is a tool that automates the creation and configuration of virtual machines, making it easier to build and manage lab environments without doing it manually in VirtualBox.


Explanation of Commands

"Vagrant.configure("2") do |config|"
Defines that version 2 of the Vagrant configuration format will be used.
All configuration instructions for the virtual machine are written inside this block.

"config.vm.box = "ubuntu/debian""
Specifies the base image (box) that Vagrant will download and use as the operating system of the virtual machine.
In this case, an Ubuntu or Debian box is used, which are common for network and server configurations.

"config.vm.provider "virtualbox" do |vm|"
Indicates that the virtualization provider is VirtualBox.
Inside this block, you can set additional VirtualBox options such as memory size or CPU count.

"config.vm.define "DHCPractice" do |DHCPractice|"
Creates a virtual machine named “DHCPractice.”
This allows defining multiple machines inside the same Vagrantfile if needed.

"DHCPractice.hostname = "DHCPractice""
Sets the hostname inside the guest operating system, which helps identify the machine on the network.

"DHCPractice.vm.network "private_network", ip: "192.168.56.21""
"DHCPractice.vm.network "private_network", ip: "192.168.57.21""
Creates two private network interfaces.
Private networks in Vagrant allow communication between the virtual machine and the host, or between multiple VMs, without external Internet access.
Each interface is assigned a static IP address, which is useful when configuring the DHCP service later.