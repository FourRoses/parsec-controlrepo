class profile::setup {

  if $::osfamily == 'RedHat' {
    #include ::yum
    #realize(Yum::Repo['puppet', 'puppet_deps'])
    class {'epel':
      epel_mirrorlist => 'absent',
      epel_baseurl    => 'http://16.0.96.20:3142/epel.mirrors.ovh.net/epel/$releasever/$basearch'
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
