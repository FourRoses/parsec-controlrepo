class profile::network {
  network::interface { $::foreman_interfaces[0][identifier]:
    ipaddress => $::foreman_interfaces[0][ip],
    netmask   => $::foreman_interfaces[0][subnet][mask],
    hwaddr    => $::foreman_interfaces[0][mac],
    gateway   => regsubst($::foreman_interfaces[0][ip], '^(\d+\.\d+\.\d+)\.\d+$', '\1.1')
  }

  if $::osfamily == 'Debian' {
    udev::rule { '71-persistent-net.rules':
      ensure  => present,
      content => "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"${::foreman_interfaces[0][mac]}\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"${::foreman_interfaces[0][identifier]}\"\n",
    }
  }
}
