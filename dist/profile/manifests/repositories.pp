class profile::repositories {

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
      release  => "${::lsbdistcodename}-security",
    }
    apt::source {'ubuntu-updates':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
      release  => "${::lsbdistcodename}-updates",
    }
    apt::source {'ubuntu-backports':
      location => 'http://16.0.96.20:3142/archive.ubuntu.com/ubuntu',
      repos    => 'main restricted universe multiverse',
      release  => "${::lsbdistcodename}-backports",
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
}
