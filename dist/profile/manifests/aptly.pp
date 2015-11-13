class profile::aptly {

  file_line { 'system-wide proxy':
    path => '/etc/environment',
    line => 'http_proxy=http://amiweb:webami@10.2.21.50:8080/',
  }

  apt::source { 'aptly':
    ensure   => present,
    location => 'http://16.0.96.20:3142/repo.aptly.info',
    release  => 'squeeze',
    repos    => 'main',
    key      => {
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

  aptly::mirror { 'puppetlabs-trusty':
    location      => 'http://apt.puppetlabs.com/',
    repos         => ['PC1', 'main', 'dependencies'],
    key           => '4BD6EC30',
    architectures => ['i386', 'amd64'],
    release       => 'trusty',
  }
  aptly::mirror { 'trusty-main':
    location      => 'http://archive.ubuntu.com/ubuntu',
    repos         => ['main'],
    key           => '437D05B5',
    architectures => ['i386', 'amd64'],
    release       => 'trusty',
  }
}
