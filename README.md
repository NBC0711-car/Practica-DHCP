---

# DHCP Server Configuration with Vagrant and VirtualBox

---

## Introduction

This practice creates a virtual environment to configure a **DHCP server** using **Vagrant** and **VirtualBox**.
Vagrant automates the creation and configuration of virtual machines, making it easier to build lab environments without manual setup in VirtualBox.

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Configuration Explanation

### Base Vagrant Setup

```ruby
Vagrant.configure("2") do |config|
```

Specifies that version 2 of the Vagrant configuration format will be used.
All configuration instructions for the virtual machines are written inside this block.

```ruby
config.vm.box = "ubuntu/debian"
```

Defines the base image (**box**) that Vagrant will download and use as the operating system.
In this case, an **Ubuntu** or **Debian** distribution.

```ruby
config.vm.provider "virtualbox" do |vm|
```

Indicates that the virtualization provider is **VirtualBox**.
Inside this block, additional settings such as memory and CPU count can be defined.

```ruby
config.vm.define "DHCPractice" do |DHCPractice|
  DHCPractice.hostname = "DHCPractice"
  DHCPractice.vm.network "private_network", ip: "192.168.56.21"
  DHCPractice.vm.network "private_network", ip: "192.168.57.21"
end
```

This sets up the **DHCPractice** VM with two private network interfaces and static IPs.

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Creating Virtual Machines: c1 and c2

### Machine c1

```ruby
config.vm.define "c1" do |c1|
  c1.vm.hostname = "c1"
  c1.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
end
```

* Creates the VM named **c1**
* Connects to an internal network called **dhcp-internal**
* Obtains its IP dynamically through **DHCP**

### Machine c2

```ruby
config.vm.define "c2" do |c2|
  c2.vm.hostname = "c2"
  c2.vm.network "private_network", type: "dhcp", virtualbox__intnet: "dhcp-internal"
  c2.vm.base_mac = "080027112233"
end
```

* Creates the VM **c2**, connected to the same internal network
* Has a **fixed MAC address** to always receive the same IP from DHCP

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Step 1 – Check Vagrant Environment Status

```bash
vagrant status
```

Expected result:

* “practice” → running
* “c1” and “c2” → not created

This confirms that only the main VM is active.

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Step 2 – Configure the DHCP Server

Edit the DHCP server configuration file:

```bash
/etc/dhcp/dhcpd.conf
```

Example configuration:

```bash
subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.100 192.168.57.200;
  option routers 192.168.57.10;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 8.8.8.8 4.4.4.4;
  option domain-name "micasa.es"
  default-lease-time 3600;
}

host c2 {
  hardware ethernet 08:00:27:11:22:33;
  fixed-address 192.168.57.4;
}
```

* Defines the subnet, IP range, router, DNS, lease time
* Reserves a static IP for `c2`

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Step 3 – Edit DHCP Configuration File

The above configuration:

* Assigns **dynamic IPs** from 192.168.57.100 to 192.168.57.200
* Reserves a **static IP** (192.168.57.4) for client c2
* Defines router as 192.168.57.10
* Sets subnet mask to 255.255.255.0
* Uses DNS 1.1.1.1
* Default lease time 3600 seconds

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Step 4 – Restart and Verify DHCP Service

Restart the service:

```bash
sudo systemctl restart isc-dhcp-server
```

Check status:

```bash
sudo systemctl status isc-dhcp-server --no-pager | head -n 5
```

If it shows **active (running)**, the DHCP service is working correctly.

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---

## Step 5 – Connect to Client and Verify IP

Connect to client `c1`:

```bash
vagrant ssh c1
```

Check network interfaces and IP:

```bash
ip a
```

Expected output:

* Interface `eth1` shows IP `192.168.57.100` assigned dynamically by DHCP

[Back to top](#dhcp-server-configuration-with-vagrant-and-virtualbox)

---
