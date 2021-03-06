#!/bin/bash

. /vagrant/bootstraps/common.sh

echo " ===> Setting location"
echo location=honolulu > /etc/facter/facts.d/location.txt

echo " ===> Configuring main Puppet manifest"
sed -i '/\[main\]/a manifest=/etc/puppet/modules/site/manifests/site.pp' /etc/puppet/puppet.conf
sed -i '/\[main\]/a parser=future' /etc/puppet/puppet.conf
sed -i '/\[main\]/a evaluator=current' /etc/puppet/puppet.conf

echo " ===> Copying main site puppet module"
mkdir -p /etc/puppet/modules
cp -a /vagrant/puppet/site /etc/puppet/modules

echo " ===> Configuring Hiera"
rm /etc/hiera.yaml
ln -s /etc/puppet/modules/site/ext/hiera.yaml /etc
ln -s /etc/puppet/modules/site/ext/hiera.yaml /etc/puppet
gem install deep_merge

echo " ===> Checking if SSL cert exists."
echo " ===> and generating one if it doesnt."
if [ ! -e "$(puppet config print hostcert)" ]; then
  puppet cert generate $(puppet config print certname)
fi

echo " ===> Installing Librarian Puppet Simple"
gem install librarian-puppet-simple

echo " ===> Installing Modules"
cd /etc/puppet/
librarian-puppet install --puppetfile=/etc/puppet/modules/site/ext/Puppetfile

echo " ===> Installing PuppetDB"
apt-get -y install puppetdb
cd /root
echo include puppetdb > pdb.pp
echo include puppetdb::master::config >> pdb.pp
puppet apply --verbose pdb.pp
rm pdb.pp

echo " ===> Installing Puppet Master Role"
puppet apply --verbose /etc/puppet/modules/site/manifests/site.pp
