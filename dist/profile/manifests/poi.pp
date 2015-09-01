class profile::poi (
  $apps,
) {

  class {'::snmp':
    agentaddress => hiera('snmp::agentaddress'),
    views        => hiera('snmp::views'),
    com2sec      => hiera('snmp::com2sec'),
  }

  include ::interfaces

  # ::metro
  user { 'opermm':
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

  # ::xprintidle
  package {'libXScrnSaver':
    ensure  => latest,
  }
  file {'/usr/bin/xprintidle':
    ensure  => present,
    replace => false,
    source  => 'puppet:///data/poi/xprintidle.i386',
    mode    => '0755',
  }

  include ::incron

  # ::swaks
  package {'swaks':
    ensure => installed,
  }

  # ::zenity
  package {'zenity' :
    ensure => installed,
  }

  # ::xdotool
  file {'/var/tmp/xdotool.rpm':
    ensure => file,
    source => 'puppet:///data/poi/xdotool-2.20110530.1-1.of.el5.i386.rpm',
  }
  package {'xdotool':
    ensure   => present,
    provider => 'rpm',
    source   => '/var/tmp/xdotool.rpm',
  }

  # ::audio
  package {'alsa-utils': }
  package {'sox': }
  exec {'/bin/alsaunmute 0':
    onlyif  => '/usr/bin/amixer get -c 0 Master | grep off]',
    require => Package['alsa-utils'],
  }

  # ::firefox
  package {'firefox':
    ensure => installed,
  }

  # ::java
  file {'/var/tmp/jre-6u29-linux-i586.rpm':
    ensure => present,
    source => 'puppet:///data/poi/jre-6u29-linux-i586.rpm',
  } ->
  package {'jre-1.6.0_29-fcs':
    ensure   => installed,
    provider => 'rpm',
    source   => '/var/tmp/jre-6u29-linux-i586.rpm',
  } ->
  class {'java':
    package => 'jre-1.6.0_29-fcs',
  }

  include ::metro::misc::captura
  include ::metro::misc::fonts
  include ::metro::misc::bashprofile
  include ::metro::poi
  if $::hostname == 'poim3' {
    include metro::misc::compartido
  }
  if member($apps, 'ctc') {
    include metro::xsession
    include metro::xresources
    include metro::misc::xlinks
    include metro::ctc
    include metro::misc::botones
    include metro::misc::rkiosk
    class {'metro::tn':
      autostart  => false,
      monitor    => false,
      decoration => 'border',
    }
    class {'metro::sirei':
      autostart  => false,
      monitor    => false,
      decoration => 'border',
    }
  }
  if member($apps, 'rctc') {
    include metro::xsession_replica
    include metro::xresources
    include metro::misc::xlinks
    class { 'metro::ctc':
      xsession => '.xsession_replica',
    }
  }
  if member($apps, 'igcamaras') {
    include metro::xsession
    include metro::igcamaras
  }
  if member($apps, 'megafonia') {
    include metro::xsession
    include metro::xresources
    include metro::megafonia
  }
  if member($apps, 'siv') {
    include metro::xsession
    include metro::xresources
    include metro::misc::xlinks
    include metro::sico::keys
    class {'metro::sico': } ->
    class {'metro::siv::client': }
  }
  if member($apps, 'xpostit') {
    include metro::xsession
    include metro::xpostit
  }
  if member($apps, 'enrutador') {
    include metro::xsession
    include metro::enrutador
  }
  if member($apps, 'tn') {
    include metro::xsession
    include metro::tn
  }
  if member($apps, 'sirei') {
    include metro::xsession
    include metro::sirei
  }
  if member($apps, 'rt') {
    include metro::xsession
    include metro::xresources
    include metro::rt
  }
  if member($apps, 'ctcligero') {
    include metro::xsession
    include metro::ctcligero
  }
  if member($apps, 'tce') {
    include metro::xsession
    include metro::xresources
    include metro::misc::xlinks
    include metro::sico::keys
    class {'metro::sico': } ->
    class {'metro::tce::client' : }
  }
  if member($apps, 'isacd') {
    include metro::xsession
    class {'metro::isacd':}
  }
  if member($apps, 'vncpogui') {
    include ::vncviewer
    include metro::vncpogui
    class {'elotouch':
      monitor => hiera(metro::vncpogui::monitor)
    }
  }
  if member($apps, 'herramienta') {
    include metro::herramienta
  }
  if member($apps, 'controlpantallas') {
    include metro::misc::controlpantallas
  }
}
