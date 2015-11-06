class profile::aptly {

  apt::source { 'aptly':
    ensure      => present,
    location    => 'http://16.0.96.20:3142/repo.aptly.info',
    release     => 'squeeze',
    repos       => 'main',
    key         => {
      'id'      => 'B6140515643C2AE155596690E083A3782A194991',
      'server'  => 'keys.gnupg.net',
      'options' => 'http-proxy="http://16.0.96.20:3128"',
    },
    include  => {
      'src' => false,
      'deb' => true,
    },
  } ->
  class {'::aptly':
    repo => false,
  }
}
