class site::roles::puppetmaster {
  include site::profiles::ssh
  include site::profiles::puppetmaster
}
