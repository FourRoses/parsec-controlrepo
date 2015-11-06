class profile::siv_solo {

  yumrepo {'poi':
    ensure   => present,
    baseurl  => 'http://16.0.96.20/repo/poi',
    gpgcheck => '0',
    descr    => 'Metro POIs',
  }

  # ::interfaces
  class { '::network':
    config_file_notify => '',
  }

  network::interface { $::foreman_interfaces[0][identifier]:
    ipaddress => $::foreman_interfaces[0][ip],
    netmask   => $::foreman_interfaces[0][subnet][mask],
    hwaddr    => $::foreman_interfaces[0][mac],
    gateway   => regsubst($::foreman_interfaces[0][ip], '^(\d+\.\d+\.\d+)\.\d+$', '\1.1')
  }

  if $::foreman_interfaces[1] {
    network::interface { $::foreman_interfaces[1][identifier]:
      ipaddress => $::foreman_interfaces[1][ip],
      netmask   => $::foreman_interfaces[1][subnet][mask],
      hwaddr    => $::foreman_interfaces[1][mac],
    }
  }

  # ::metro
  user {'opermm':
    ensure     => 'present',
    uid        => '502',
    gid        => '501',
    groups     => 'uucp',
    comment    => 'Usuario que lanza el CTC',
    home       => '/home/opermm',
    managehome => true,
    shell      => '/bin/bash',
    password   => '$1$2ytnzzj8$jQpaUPnccZDw2YVpzqzNs/',
  }
  group { 'ctcing':
    ensure => 'present',
    gid    => '501',
  }

  # ::x11
  package {['xorg-x11-server-Xorg', 'xorg-x11-apps', 'xorg-x11-xinit', 'xterm']:
    ensure => present,
  }
  package {'xorg-x11-server-Xvfb':
    ensure => present,
  }
  $x11_template = hiera('x11::conf_content')
  if $x11_template == 'absent' {
    file {'/etc/X11/xorg.conf':
      ensure  => 'absent',
    }
  } else {
    file {'/etc/X11/xorg.conf':
      ensure  => present,
      content => template($x11_template),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
  augeas {'inittab':
    changes => ['set /files/etc/inittab/id/runlevels 5',],
  }
  package {['fonts-ISO8859-2','fonts-ISO8859-2-100dpi',
            'fonts-ISO8859-2-75dpi','xorg-x11-fonts-ISO8859-1-75dpi',
            'xorg-x11-fonts-ISO8859-2-75dpi','xorg-x11-fonts-ISO8859-1-100dpi',
            'xorg-x11-fonts-ISO8859-2-100dpi','xorg-x11-fonts-Type1']:
    ensure => present,
  }

  # ::gdm
  package {'gdm':
    ensure => installed,
  }
  file { '/etc/gdm/custom.conf' :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('metro/custom.conf.erb'),
  }

  # ::pexserver
  package {'sico-pexserver-sivtce':
    ensure => latest,
  } ->
  file {'/usr/local/sico/lib/libXm.so.2':
    ensure => link,
    target => '/usr/X11R6/lib/libXm.so.2',
  } ->
  file {'/usr/local/sico/pexserver/functions':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///data/poi/common/usr/local/sico/pexserver/functions',
  } ->
  file {'/etc/init.d/SicoPexServer':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///data/poi/common/etc/init.d/SicoPexServer',
  } ->
  service {'SicoPexServer':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => false,
  }

  # ::openmotif
  package {'openmotif':
    ensure => present,
  }
  package {'openmotif22':
    ensure => present,
  }

  include ::incron

  # ::swaks
  package {'swaks':
    ensure => installed,
  }
  # ::zenity
  package {'zenity':
    ensure => installed,
  }

  include ::x11vnc

  include ::metro
  include ::metro::xsession
  include ::metro::xresources
  include ::metro::misc::xlinks
  include ::metro::misc::fonts
  include ::metro::sico::keys

  include ::metro::misc::compruebalogin
  include ::metro::misc::finsesion

  class {'metro::misc::x11vnc_broker':
    port => '10002',
  }
  
  class {'metro::sico': } ->
  class {'metro::siv::client':
    monitor => '0',
    fixed   => true,
  }
}
