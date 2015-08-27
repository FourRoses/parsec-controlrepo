class profile::sivestacion {
  #class {'::user::siv': } ->
  #class {'::dkms': } ->
  #class {'::metro::siv::estacion': } ->
  #class {'::rlogin': } ->
  #Class ['::profile::sivestacion']

  package {['libncurses5-dev','libssl-dev','libssl0.9.8']: }
  package {'tcsh': }

#  network_config { $::foreman_interfaces[0][identifier]:
#    ensure    => 'present',
#    family    => 'inet',
#    ipaddress => $::foreman_interfaces[0][ip],
#    method    => 'static',
#    mode      => 'raw',
#    netmask   => '255.255.255.0',
#    onboot    => 'true',
#  }

  network::interface { $::foreman_interfaces[0][identifier]:
    ipaddress => $::foreman_interfaces[0][ip],
    netmask   => $::foreman_interfaces[0][attrs][netmask],
  }
}
