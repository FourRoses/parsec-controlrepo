class profile::worker {
  include ::interfaces
  include ::dnsclient
  include ::empty
  include ::nfs::client

  class {'::user::nagios':
    stage => first}
  class {'::metro::nagios_checks':
    path  => '/cosmos/nagios/libexec',
    user  => 'nagios',
    group => 'nagios',
  }
  class {'::nagiosbp':
  }
  class {'::mod_gearman::worker':
    server => '16.0.74.31:4730',
  }
  class {'::snmp::client': }
}
