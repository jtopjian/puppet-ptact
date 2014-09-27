#!/bin/bash

cd /root
echo " ===> Setting acng server"
echo " ===> Acquire::http { Proxy \"http://acng-yyc.cloud.cybera.ca:3142\"; };"  > /etc/apt/apt.conf.d/01-acng

echo " ===> Adding repositories"
apt-add-repository -y ppa:ubuntu-lxc/stable

echo " ===> Updating apt"
apt-get update

echo " ===> Installing curl and wget"
apt-get install -y curl wget

echo " ===> Installing standard packages"
apt-get install -y git rake ruby facter

echo " ===> Setting up dotfiles"
git clone https://github.com/jtopjian/dotfiles .dotfiles
cd /root/.dotfiles
bash create.sh

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

cat > /etc/lxc/default <<EOF
lxc.network.link = "lxcbr0"
lxc.network.ipv4.gateway = "192.168.255.1"
EOF

restart lxc
pkill -9 dnsmasq

ip addr del $IP/24 dev lxcbr0
ip addr add 192.168.255.1/24 dev lxcbr0

echo " ===> Installing Vagrant"
apt-get install -y ruby-dev build-essential libxslt-dev libxml2-dev
wget --quiet https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb
dpkg -i vagrant*.deb
rm vagrant*.deb
vagrant plugin install vagrant-openstack-plugin
vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box
vagrant plugin install vagrant-lxc
