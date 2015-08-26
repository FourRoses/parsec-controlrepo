class profile::puppetmasterca {
  include ::base
  class {'::puppet::server':
    passenger => false,
    service_fallback => false,
    ca => false,
    foreman_url => 'https://servimg.set.winumi.net',
  }
}
