class profile::tftp {
  include ::tftp
  class {'foreman_proxy':
    puppetca  => false,
    puppetrun => false,
    ssl       => false,
    ssl_ca    => false,
    ssl_cert  => false,
    ssl_key   => false,
  }
}
