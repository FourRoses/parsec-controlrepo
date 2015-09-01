class profile::sivestacion {
  #class {'::metro::siv::estacion': } ->

  class {'::snmp':
    agentaddress      => hiera('snmp::agentaddress'),
    views             => hiera('snmp::views'),
    com2sec           => hiera('snmp::com2sec'),
    snmpd_config      => hiera('snmp::snmpd_config'),
    service_hasstatus => hiera('snmp::service_hasstatus'),
  }


  package {['libncurses5-dev','libssl-dev','libssl0.9.8']: } # for dgrp compatibility

  package {'tcsh': }

  network::interface { $::foreman_interfaces[0][identifier]:
    ipaddress => $::foreman_interfaces[0][ip],
    netmask   => $::foreman_interfaces[0][attrs][netmask],
    gateway   => regsubst($::foreman_interfaces[0][ip], '^(\d+\.\d+\.\d+)\.\d+$', '\1.1')
  }
  udev::rule { '70-persistent-net.rules':
    ensure  => present,
    content => "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"${::foreman_interfaces[0][mac]}\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"${::foreman_interfaces[0][identifier]}\"\n",
  }

  package {'rsh-redone-server': }
  xinetd::service {'login':
    server => '/usr/sbin/in.rlogind',
    port   => '513',
    wait   => 'no',
  }
  xinetd::service {'shell':
    server => '/usr/sbin/in.rshd',
    port   => '514',
    wait   => 'no',
  }

  user { 'siv':
    ensure     => present,
    uid        => '201',
    gid        => '503',
    groups     => 'audio',
    comment    => 'Usuario aplicacion SICO',
    home       => '/home/siv',
    password   => '$1$5rsm.4fQ$VheMuU8NS0GTzoYYpRYLZ0',
    shell      => '/bin/csh',
    managehome => true,
  }

  group { 'siv':
    ensure => present,
    gid    => '503',
  }

  package { ['build-essential', "linux-headers-${::kernelrelease}"]: }
  package { 'dkms': }

}
