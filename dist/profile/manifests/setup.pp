class profile::setup {

  if $::osfamily == 'RedHat' {
    resources {'yumrepo':
      purge => true,
    }
    class {'epel':
      epel_mirrorlist => 'absent',
      epel_baseurl    => 'http://16.0.96.20:3142/epel.mirrors.ovh.net/epel/$releasever/$basearch'
    }

    yumrepo { 'centos-base':
      baseurl => 'http://16.0.96.20:3142/centos.mirrors.ovh.net/ftp.centos.org/$releasever/os/$basearch',
      gpgkey  => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${facts['operatingsystemmajrelease']}",
      descr   => "CentOS-${facts['operatingsystemmajrelease']} - Base",
    }
    yumrepo { 'centos-updates':
      baseurl => 'http://16.0.96.20:3142/centos.mirrors.ovh.net/ftp.centos.org/$releasever/updates/$basearch',
      gpgkey  => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${facts['operatingsystemmajrelease']}",
      descr   => "CentOS-${facts['operatingsystemmajrelease']} - Updates",
    }
    yumrepo { 'puppetlabs':
      baseurl  => 'http://16.0.96.20:3142/yum.puppetlabs.com/el/$releasever/products/$basearch',
      descr    => 'PuppetLabs Products',
      gpgcheck => '0'
    }
    yumrepo { 'puppetlabs-deps':
      baseurl  => 'http://16.0.96.20:3142/yum.puppetlabs.com/el/$releasever/dependencies/$basearch',
      descr    => 'PuppetLabs Dependencies',
      gpgcheck => '0'
    }
  }

  user {'root':
    ensure         => 'present',
    uid            => '0',
    gid            => '0',
    purge_ssh_keys => true,
    home           => '/root',
  }
}
