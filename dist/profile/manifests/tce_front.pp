class profile::tce_front {
  $network = regsubst($::ipaddress,'(\d+)$','0')

  include ::motd

  file_line { 'auto_home':
    ensure => 'absent',
    path   => '/etc/auto_master',
    line   => '/home		auto_home	-nobrowse',
  } ~>
  service { 'svc:/system/filesystem/autofs:default':
    ensure => 'running',
    enable => true,
  }
  user { 'metro':
    ensure   => present,
    uid      => '101',
    gid      => '60001',
    home     => '/home/metro',
    shell    => '/usr/bin/csh',
    password => '$6$1GrmvjyT$rXNSNGEma8eMmlTYBBzNQURNXAxHu8OvyPr9mXtxbhemWJi89hoZDm5ytSI4Z4NQbn2DDCEzDpZHQ27ikyCHS0',
  }
  user { 'siv':
    ensure   => present,
    uid      => '102',
    gid      => '60001',
    home     => '/home/siv',
    shell    => '/usr/bin/csh',
    password => '$6$1GrmvjyT$rXNSNGEma8eMmlTYBBzNQURNXAxHu8OvyPr9mXtxbhemWJi89hoZDm5ytSI4Z4NQbn2DDCEzDpZHQ27ikyCHS0',
  }
  user { 'root':
    ensure   => 'present',
    uid      => '0',
    gid      => '0',
    shell    => '/usr/bin/bash',
    password => 'pveboAFZFAX6c',
  }

  service { 'svc:/application/gdm2-login:default':
    ensure => 'stopped',
    enable => false,
  }
  service { 'svc:/application/graphical-login/cde-login:default':
    ensure => 'stopped',
    enable => false,
  }
  service { 'svc:/network/stlisten:default':
    enable => false,
  }
  service { 'svc:/network/stdiscover:default':
    enable => false,
  }
  service { 'svc:/network/smtp:sendmail':
    ensure => 'stopped',
    enable => false,
  }
  service { 'svc:/network/sendmail-client:default':
    ensure => 'stopped',
    enable => false,
  }
  service { 'webconsole':
    ensure => 'stopped',
    enable => false,
  }

  file { '/etc/pkgadmin':
    ensure  => present,
    content => "basedir=default\nconflict=quit\nsetuid=nocheck\naction=nocheck\npartial=nocheck\ninstance=overwrite\nidepend=quit\nrdepend=quit\nspace=quit\n",
  }

  file { '/home/metro':
    ensure       => directory,
    owner        => 'metro',
    group        => 'nobody',
    sourceselect => all,
    source       => ["puppet:///modules/metro/tce/configs/front/${::hostname}/home/metro",
                     'puppet:///modules/metro/tce/configs/front/base/home/metro'],
    recurse      => remote,
    require      => File_line['auto_home'],
  }
  file { '/home/metro/sun':
    ensure  => directory,
    owner   => 'metro',
    group   => 'nobody',
    source  => 'puppet:///modules/metro/tce/bin/front/sun',
    recurse => true,
    mode    => '0755',
  }
  file { '/home/metro/.cshrc':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => 'puppet:///modules/metro/tce/cshrc',
    mode   => '0644',
  }
  file { '/home/metro/.autoarranque':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => 'puppet:///modules/metro/tce/autoarranque',
    mode   => '0755',
  }
  file { '/home/metro/autostart':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => 'puppet:///modules/metro/tce/autostart',
    mode   => '0755',
  }
  file_line { 'autoarranque':
    ensure => 'present',
    path   => '/etc/inittab',
    line   => 'co:234:respawn:/home/metro/.autoarranque >/dev/null 2>&1 </dev/null',
  }

  file { '/etc/inet':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/metro/tce/configs/front/${::hostname}/etc/inet",
    recurse => remote,
    mode    => '0444',
  }
  file { '/usr/lib':
    ensure  => directory,
    owner   => 'root',
    group   => 'bin',
    source  => 'puppet:///modules/metro/tce/libs',
    recurse => remote,
  }

  class { 'ntp':
    service_name  => 'ntp4',
    config        => '/etc/inet/ntp.conf',
    package_name  => ['SUNWntp4r','SUNWntp4u'],
    servers       => ['router1_sur'],
    iburst_enable => true,
  }

  service { 'svc:/network/time:dgram':
    ensure => 'running',
    enable => true,
  }
  service { 'svc:/network/time:stream':
    ensure => 'running',
    enable => true,
  }

  file { '/usr/bin/distsh2':
    ensure => present,
    source => 'puppet:///modules/metro/tce/distsh2',
    owner  => 'root',
    group  => 'root',
    mode   => '4555',
  }

  file_line { 'controlsico1':
    ensure => 'present',
    path   => '/etc/rpc',
    line   => 'controlsico1    805306368',
  }
  file_line { 'controlsico2':
    ensure => 'present',
    path   => '/etc/rpc',
    line   => 'controlsico2    805306369',
  }
  file { '/etc/hosts.equiv':
    ensure  => file,
    content => "+\n",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
#  file { '/usr/local':
#    ensure  => directory,
#    source  => 'puppet:///modules/metro/tce/configs/front/base/usr/local',
#    recurse => remote,
#  }

  file_line { 'default path':
    ensure => 'present',
    path   => '/etc/profile',
    line   => 'PATH="/opt/csw/bin:/usr/sbin:/usr/bin"',
    match  => '^PATH.*$',
  } ->
  file_line { 'export path':
    ensure => 'present',
    path   => '/etc/profile',
    line   => 'export PATH',
    after  => '^PATH.*$',
  }
  file_line { 'default manpath':
    ensure => 'present',
    path   => '/etc/profile',
    line   => 'MANPATH="/opt/csw/share/man:/usr/share/man"',
    match  => '^MANPATH.*$',
  } ->
  file_line { 'export manpath':
    ensure => 'present',
    path   => '/etc/profile',
    line   => 'export MANPATH',
    after  => '^MANPATH.*$',
  }
  file_line { 'delete backspace':
    ensure => 'present',
    path   => '/etc/profile',
    line   => 'stty erase ',
  }
  file_line { 'proxy pkgutil':
    ensure => 'present',
    path   => '/etc/opt/csw/pkgutil.conf',
    line   => 'wgetopts=-nv --execute http_proxy=http://16.0.96.20:3128',
    match  => '^wgetopts.*$',
  } ->
  package { 'CSWsocat':
    ensure   => present,
    provider => 'pkgutil',
  } ->
  package { ['CSWcoreutils','CSWvim','CSWtop','CSWgtar','CSWfindutils','CSWgawk','CSWggrep','CSWgsed'] :
    ensure   => present,
    provider => 'pkgutil',
  }
  package { 'CSWexpect' :
    ensure   => present,
    provider => 'pkgutil',
  }

  exec { '/usr/bin/rm /etc/dhcp.*' :
    onlyif => '/usr/bin/ls /etc/dhcp.*',
  }

  file { '/etc/defaultrouter' :
    ensure  => present,
    content => "router1_sur\n",
  }

  file {'/etc/inet/netmasks':
    ensure  => present,
    content => "${network} 255.255.255.0\n",
    owner   => 'root',
    group   => 'sys',
    mode    => '0444',
  }

  cron { 'reboot' :
    command => '/usr/sbin/sync; /usr/sbin/reboot -q',
    user    => root,
    hour    => 4,
    minute  => 20,
  }
  cron { 'freevar' :
    command => '/usr/local/bin/freevar.sh',
    user    => root,
    minute  => 0,
  }
  cron { 'captura_repositorio' :
    command => '/home/metro/sun/CapturarFicherosRepositorio.sh',
    user    => root,
    hour    => 2,
    minute  => 10,
  }
  file { '/var/spool/cron/crontabs/metro':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/metro/tce/configs/front/${::hostname}/var/spool/cron/crontabs/metro",
    mode   => '0400',
  }
  file { '/etc/init.d/logclean_metro':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/metro/tce/logclean_metro',
  }
  file {'/etc/rc2.d/S03logclean_metro':
    ensure => link,
    target => '/etc/init.d/logclean_metro',
  }

  class {'puppet':
    listen         => false,
    pluginsync     => true,
    runinterval    => '3600',
    runmode        => 'cron',
    puppetmaster   => 'parsec.silex.metromadrid.net',
    service_name   => 'svc:/network/cswpuppetd:default',
    client_package => 'CSWpuppet3',
    cron_cmd       => '/usr/bin/env /opt/csw/bin/puppet agent --config /etc/puppet/puppet.conf --onetime --no-daemonize',
  }

}
