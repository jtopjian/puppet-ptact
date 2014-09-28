#!/bin/bash

. /vagrant/bootstraps/common.sh

echo " ===> Setting location"
echo location=honolulu > /etc/facter/facts.d/location.txt

echo " ===> Creating host entry for Puppet Master"
echo 192.168.255.2 puppet.example.com puppet >> /etc/hosts
