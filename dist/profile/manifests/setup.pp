class profile::setup {

  # Apaño mientras no unifique yum/apt
  if $::osfamily == 'RedHat' {
    include ::yum
    realize(Yum::Repo['puppet', 'puppet_deps'])
  }

  user {'root':
    ensure         => 'present',
    uid            => '0',
    gid            => '0',
    purge_ssh_keys => true,
    home           => '/root',
  }
}
