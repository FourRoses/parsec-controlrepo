class profile::base {
  include ::stdlib
  include ::motd
  include ::vim
  include ::xinetd

  class {'dnsclient':
    nameservers => hiera('dnsclient::nameservers'),
  }

  class {'profile::setup':
    stage => 'setup',
  }

  include ::profile::vmtools

  if $::osfamily == 'Debian' {
    class {'::apt':
      purge => {
        'sources.list'       => true,
        'sources.list.d'     => true,
        'preferences.list'   => true,
        'preferences.list.d' => true,
      }
    }

    apt::source {'ubuntu':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
    }
    apt::source {'ubuntu-security':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
      release  => "${lsbdistcodename}-security",
    }
    apt::source {'ubuntu-updates':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
      release  => "${lsbdistcodename}-updates",
    }
    apt::source {'ubuntu-backports':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
      release  => "${lsbdistcodename}-backports",
    }
    apt::source {'puppetlabs':
      location => 'http://16.0.96.20/repo/apt.puppetlabs.com',
      repos    => 'main dependencies',
      key      => {
        'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
        'source' => 'http://16.0.96.20/repo/puppet/pubkey.gpg',
      }
    }
  }

  class {'::puppet':
    version     => 'latest',
    runmode     => 'cron',
    runinterval => '3600',
    show_diff   => true,
  }

  class {'::ntp':
    servers       => hiera('ntp::params::servers'),
    iburst_enable => true,
  }

  class {'ssh':
    server_options => {
      'GSSAPIAuthentication' => 'no',
      'UseDNS'               => 'no',
      'PermitRootLogin'      => 'yes',
      'PrintMotd'            => 'yes',
    },
  }

  ssh_authorized_key { 'juanjop@t5400':
    user => 'root',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDdQbBN8LrvMIwl34lXmZ8tFj6oa9bXeLzy+QQCn6dvZMWFh3yD5Mdx9iv7DVDSZyJYoT6RqKA+qFGnOCU/HcKkFCwrK1Z0CRmJR/dmZrc+tfqtXOU60Lb4mEnUkcWhRJm9dfF4XYuTNR4x7qflaMn8yDkUYaaUK1Aj5a1uadJvII10OQVoT2GTFFhB82mITLNYrQR9WpuAVKrEn52i37rSDtMmU9GHq6jHkfckTfi8C+MVkcLSjluzm0cq+kePdw4V3WYJXbOsFfPWfMwWSOi/5cobiKiYIenxldWKjkk1UvfGUZcBkDrAmQDLq5KUKLRrB+kjb2XLTy0Ap/a2/2QJ',
  }

  ssh_authorized_key { 'root@wminpsu01':
    user => 'root',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA20/PRghF40nal+EqAbkIZfz2TKMMhYx5gnfzdMmWmXZLjyfjZ/krf4EWLzLeB9QzcEw5v+Os6PnD45xHOUic36w8bxNooJaBq/DflHtUUMTa66OIt91mBRZyTJ2napfVDSCDq9hqkVpO9HSyUPLp6c63BwR88nNupsIEuxWB0Ix7R2TAMl9kT6bhVkVVUd2/YYFX3AYN/yjE6nqUET+bffTmg+44gVgbL2drZsVKzL7ATGSq5rHd/PdaKa6WIZl0tIw+ut+POX/xSV3F3E/RGhait7DvFL5ZQDOfhzl0sV40IiiTBF6l43sN+IFMvNBuUTxFxdUUx+lwjPs0wIv9wQ==',
  }

  package { 'netcat':
    ensure => installed,
  }
}
