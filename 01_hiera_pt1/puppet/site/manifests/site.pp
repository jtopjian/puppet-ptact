node 'puppet.example.com' {
  include site::roles::puppetmaster
}

node 'node-1.example.com' {
  include site::roles::standard
}

node 'node-2.example.com' {
  include site::roles::standard
}
