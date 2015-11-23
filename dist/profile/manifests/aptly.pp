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

  aptly::mirror { 'puppetlabs-trusty-i386':
    location      => 'http://apt.puppetlabs.com/',
    repos         => ['PC1', 'main', 'dependencies'],
    key           => '4BD6EC30',
    architectures => ['i386'],
    release       => 'trusty',
  }
  aptly::mirror { 'trusty-main-i386':
    location      => 'http://archive.ubuntu.com/ubuntu',
    repos         => ['main'],
    key           => '437D05B5',
    architectures => ['i386'],
    release       => 'trusty',
  }
  aptly::mirror { 'trusty-security-main-i386':
    location      => 'http://archive.ubuntu.com/ubuntu',
    repos         => ['main'],
    key           => '437D05B5',
    architectures => ['i386'],
    release       => 'trusty-security',
  }
  aptly::mirror { 'trusty-updates-main-i386':
    location      => 'http://archive.ubuntu.com/ubuntu',
    repos         => ['main'],
    key           => '437D05B5',
    architectures => ['i386'],
    release       => 'trusty-updates',
  }

  cron { 'aptly trusty-main-i386':
    command => '/usr/bin/aptly mirror update trusty-main-i386',
    user    => root,
    hour    => 2,
    minute  => 0
  }
  cron { 'aptly trusty-security-main-i386':
    command => '/usr/bin/aptly mirror update trusty-security-main-i386',
    user    => root,
    hour    => 3,
    minute  => 0
  }
  cron { 'aptly trusty-updates-main-i386':
    command => '/usr/bin/aptly mirror update trusty-updates-main-i386',
    user    => root,
    hour    => 4,
    minute  => 0
  }
  cron { 'aptly puppetlabs-trusty-i386':
    command => '/usr/bin/aptly mirror update puppetlabs-trusty-i386',
    user    => root,
    hour    => 5,
    minute  => 0
  }
}
