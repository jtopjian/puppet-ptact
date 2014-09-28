class site::roles::puppetmaster {
  include apache
  include apache::mod::ssl
  include apache::mod::passenger
  include puppet
  include puppet::master
  include puppetdb
  include puppetdb::master::config
}
