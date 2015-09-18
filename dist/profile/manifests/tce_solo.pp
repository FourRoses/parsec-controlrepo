class profile::tce_solo {
  include ::metro
  include ::metro::xsession
  include ::metro::xresources
  include ::metro::misc::xlinks
  include ::metro::misc::fonts
  include ::metro::sico::keys

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

  include ::x11vnc

  include ::incron
  # ::swaks
  package {'swaks':
    ensure => installed,
  }
  # ::zenity
  package {'zenity':
    ensure => installed,
  }

  include ::metro::misc::compruebalogin
  include ::metro::misc::finsesion

  class {'metro::misc::x11vnc_broker':
    port => '10001',
  }
  
  class {'metro::sico': } ->
  class {'metro::tce::client':
    monitor => '0',
    fixed   => true,
  }
}
