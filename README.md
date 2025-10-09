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

This Vagrant setup creates two virtual machines called c1 and c2. Both are connected to a private internal network that uses DHCP to hand out IP addresses. The first one gets a random IP each time, and the second one always gets the same IP because it has a fixed MAC address.

The line config.vm.define "c1" do |c1| starts the setup for the first virtual machine, named c1. Inside that block, c1.vm.hostname = "c1" sets the name the machine will use inside its operating system. Then, c1.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal" connects it to a private internal network called dhcp-internal. The “type: dhcp” part means the machine will ask for an IP address automatically when it starts up. This lets different VMs on the same network talk to each other without needing internet access. The word end just marks the end of the configuration for that VM.

After that, config.vm.define "c2" do |c2| starts the setup for the second virtual machine. Like before, c2.vm.hostname = "c2" gives it a name inside the guest OS. It connects to the same private network with c2.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal". But this one has an extra line: c2.vm.base_mac = "080027112233". That fixed MAC address tells the DHCP server to always assign this machine the same IP address, instead of a random one. This is how you can make sure a VM always gets the same IP even when using DHCP. The end closes this block too.

Finally, there’s one last end that closes the main Vagrant.configure block that wraps everything. Every VM definition has to go inside that main block so Vagrant knows what to create and configure.

In short, c1 gets a dynamic IP and c2 gets a fixed IP thanks to its MAC address. This kind of setup is great when you want to test a small internal network where some machines have static addresses and others just grab one automatically.

Step 1 – Check Vagrant Environment Status. Run the command vagrant status to see the state of all virtual machines defined in the Vagrantfile. The result shows that “practice” is running in VirtualBox, while “c1” and “c2” are not created yet. This means only the main VM is active, and the other two have not been initialized. This step helps confirm which machines are currently running before continuing with the setup.

Step 2 – Configure the DHCP Server. The file /etc/dhcp/dhcpd.conf defines how IP addresses are assigned within the network. In this configuration, the subnet 192.168.57.0 with netmask 255.255.255.0 is set up. The DHCP range goes from 192.168.57.100 to 192.168.57.200, meaning dynamic IPs will be given within that range. The router address is 192.168.57.10, and the subnet mask is specified as 255.255.255.0. Below, a fixed IP reservation is added for the client c2. The MAC address 08:00:27:11:22:33 is linked to the fixed IP 192.168.57.4, ensuring this device always receives the same address. The lease time is set to 3600 seconds (1 hour), and the DNS server is configured as 1.1.1.1. This setup provides both dynamic and static IP management for the internal network.

Step 3 – Edit the DHCP Configuration File. The file /etc/dhcp/dhcpd.conf defines how IP addresses are assigned in the network. In this setup, the subnet 192.168.57.0 with netmask 255.255.255.0 is created. The DHCP server assigns dynamic IPs in the range from 192.168.57.100 to 192.168.57.200. The router address is set to 192.168.57.10, and the subnet mask is specified as 255.255.255.0. Below this section, there is a fixed IP reservation for the client c2. The MAC address 08:00:27:11:22:33 is associated with the static IP 192.168.57.4, ensuring that this machine always gets the same address. The default lease time is 3600 seconds (1 hour), and the DNS server is configured to 1.1.1.1. This configuration allows dynamic IP assignment for most clients while reserving a specific address for c2.

Step 4 – Restart and Verify the DHCP Service. After editing the configuration file, the DHCP service must be restarted to apply the changes. The command sudo systemctl restart isc-dhcp-server restarts the service. Then, sudo systemctl status isc-dhcp-server --no-pager | head -n 5 checks if it is running correctly. The output shows that the service is loaded and active, meaning the DHCP server started successfully without errors. This confirms that the new network and IP reservation settings are now applied and the DHCP server is functioning properly.