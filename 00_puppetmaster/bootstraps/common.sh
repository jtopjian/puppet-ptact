#!/bin/bash

cd /root

echo " ===> Setting acng server"
echo " ===> Acquire::http { Proxy \"http://acng-yyc.cloud.cybera.ca:3142\"; };"  > /etc/apt/apt.conf.d/01-acng

echo " ===> Configuring DNS"
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
resolvconf -u

echo " ===> Installing the PuppetLabs apt repo"
cd /root
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
rm puppetlabs-release-trusty.deb
apt-get update

echo " ===> Installing Puppet"
apt-get install -y puppet=3.6.2-1puppetlabs1 puppet-common=3.6.2-1puppetlabs1

echo " ===> Installing standard packages"
apt-get install -y git
