class profile::sivestacion {
  #class {'::user::siv': } ->
  #class {'::dkms': } ->
  #class {'::metro::siv::estacion': } ->
  #class {'::rlogin': } ->
  #Class ['::profile::sivestacion']

  package {['libncurses5-dev','libssl-dev','libssl0.9.8']: }
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
}
