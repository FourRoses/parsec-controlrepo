class profile::puppetmaster {
  class {'::puppet::server':
    passenger => false,
    service_fallback => false,
    ca => false,
    ca_server => 'servimg.set.winumi.net',
    foreman_url => 'https://servimg.set.winumi.net',
  }
}
