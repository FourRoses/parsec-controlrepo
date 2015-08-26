class profile::base {
  include ::stdlib
  include ::motd
  include ::vim
  include ::webmin
  include ::xinetd
  include ::netcat
  include ::dnsclient

  class {'profile::setup':
    stage => 'setup',
  }

  include ::profile::vmtools

  if $::osfamily == 'Debian' {
    class {'::apt':
      purge_sources_list   => true,
      purge_sources_list_d => true,
      purge_preferences_d  => true,
    }
    include ::repos::siv
  }

#  if $::virtual == 'vmware' {
#    class {'vmware_tools': stage => 'runtime'}
#    if $::osfamily == 'RedHat' {
#      realize(Yum::Repo['vmware_tools'])
#    }
#  }

#  class { '::vmwaretools':
#    reposerver            => 'http://16.0.96.20:3142/',
#    repopath              => 'packages.vmware.com/tools',
#    just_prepend_repopath => true,
#    tools_version         => "${::vmware}latest",
#    autoupgrade           => true,
# #   stage                 => 'runtime',
#  }

  class {'::puppet':
    version     => 'latest',
    runmode     => 'cron',
    runinterval => '3600',
    show_diff   => true,
  }

  class {'::snmp':
  }

  class {'::ntp':
    servers => hiera('ntp::params::servers'),
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

}
