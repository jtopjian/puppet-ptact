#!/bin/bash

cd /root

echo " ===> Adding repositories"
apt-add-repository -y ppa:ubuntu-lxc/stable

echo " ===> Updating apt"
apt-get update

echo " ===> Installing curl and wget"
apt-get install -y curl wget

echo " ===> Installing standard packages"
apt-get install -y git rake ruby facter

echo " ===> Configuring SSH"
cat > /root/.ssh/config <<EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
EOF

echo " ===> Disabling ipv6 temporary addresses"
echo 0 > /proc/sys/net/ipv6/conf/all/use_tempaddr

echo " ===> Installing LXC"
apt-get install -y lxc

echo " ===> Configuring LXC"
IP=$(facter ipaddress_lxcbr0)

sed -i -e 's/USE_LXC_BRIDGE.*/USE_LXC_BRIDGE="false"/' /etc/default/lxc-net

cat > /etc/lxc/default.conf <<EOF
lxc.network.ipv4.gateway = 192.168.255.1
EOF

restart lxc
pkill -9 dnsmasq

ip addr del $IP/24 dev lxcbr0
ip addr add 192.168.255.1/24 dev lxcbr0

echo " ===> Configuring NAT for LXC"
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o lxcbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i lxcbr0 -o eth0 -j ACCEPT

echo " ===> Installing Vagrant"
apt-get install -y ruby-dev build-essential libxslt-dev libxml2-dev
wget --quiet https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb
dpkg -i vagrant*.deb
rm vagrant*.deb
vagrant plugin install vagrant-openstack-plugin
vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box
vagrant plugin install vagrant-lxc

echo " ===> Cloning puppet-ptact repository"
cd /root
git clone https://github.com/jtopjian/puppet-ptact
