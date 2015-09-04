class profile::tce_estacion {
  $uis_ip = hiera('metro::tce::uis_ip')
  $cancela = hiera('metro::tce::cancela')
  $mbt = hiera('metro::tce::mbt')
  $nolic = hiera('metro::tce::nolic', false)
  $plano = hiera('metro::tce::plano', true)
  $maestra_ip = hiera('metro::tce::maestra_ip', true)

  $network = regsubst($::ipaddress,'(\d+)$','0')

  if $plano {
    $login_file = 'login.plano'
  } else {
    $login_file = 'login.sinplano'
  }

  if $maestra_ip {
    $autostart_file = 'autostart.maestra_ip'
  } else {
    $autostart_file = 'autostart.sinmaestra_ip'
  }

  include ::motd

  file_line { 'auto_home':
    path   => '/etc/auto_master',
    ensure => 'absent',
    line   => '/home		auto_home	-nobrowse',
  } ~>
  service { 'svc:/system/filesystem/autofs:default':
    ensure => 'running',
    enable => true,
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

  user { 'metro':
    ensure   => present,
    uid      => '101',
    gid      => '60001',
    home     => '/home/metro',
    shell    => '/usr/bin/csh',
    password => '$6$1GrmvjyT$rXNSNGEma8eMmlTYBBzNQURNXAxHu8OvyPr9mXtxbhemWJi89hoZDm5ytSI4Z4NQbn2DDCEzDpZHQ27ikyCHS0',
  }

  user { 'root':
    ensure   => 'present',
    uid      => '0',
    gid      => '0',
    shell    => '/opt/csw/bin/bash',
    password => 'pveboAFZFAX6c',
  }
  file { '/.bashrc':
    ensure => 'absent',
  }
  file { '/.bash_profile':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///data/tce_estacion/common/bash_profile',
    mode   => '0644',
  }

  ssh_authorized_key { 'juanjop@t5400':
    user => 'root',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDdQbBN8LrvMIwl34lXmZ8tFj6oa9bXeLzy+QQCn6dvZMWFh3yD5Mdx9iv7DVDSZyJYoT6RqKA+qFGnOCU/HcKkFCwrK1Z0CRmJR/dmZrc+tfqtXOU60Lb4mEnUkcWhRJm9dfF4XYuTNR4x7qflaMn8yDkUYaaUK1Aj5a1uadJvII10OQVoT2GTFFhB82mITLNYrQR9WpuAVKrEn52i37rSDtMmU9GHq6jHkfckTfi8C+MVkcLSjluzm0cq+kePdw4V3WYJXbOsFfPWfMwWSOi/5cobiKiYIenxldWKjkk1UvfGUZcBkDrAmQDLq5KUKLRrB+kjb2XLTy0Ap/a2/2QJ',
  }

  file { '/etc/pkgadmin':
    ensure  => present,
    content => "basedir=default\nconflict=quit\nsetuid=nocheck\naction=nocheck\npartial=nocheck\ninstance=overwrite\nidepend=quit\nrdepend=quit\nspace=quit\n",
  }

  file { '/var/tmp/oss-solaris-v4.2-2011-i386.pkg':
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/var/tmp/oss-solaris-v4.2-2011-i386.pkg',
  } ->
  package { 'oss':
    ensure    => installed,
    adminfile => '/etc/pkgadmin',
    source    => '/var/tmp/oss-solaris-v4.2-2011-i386.pkg',
  }

  file { '/var/tmp/40001174_T.bin':
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/var/tmp/40001174_T.bin',
  } ->
  package { 'realport':
    ensure    => installed,
    adminfile => '/etc/pkgadmin',
    source    => '/var/tmp/40001174_T.bin',
  } ->
  file { '/opt/realport/drpadmin_auto':
    ensure => file,
    source => 'puppet:///data/tce_estacion/common/opt/realport/drpadmin_auto',
    mode   => '0750',
    owner  => 'root',
    group  => 'other',
  } ->
  exec { "/opt/realport/drpadmin_auto ${uis_ip}":
    unless => "/usr/bin/grep ${uis_ip} /opt/realport/drp.conf"
  }

  file { '/usr/lib/security/pam_allow.so.1':
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/usr/lib/security/pam_allow.so.1',
  }
  file_line { 'pam_unix_cred.so.1':
    path   => '/etc/pam.conf',
    ensure => 'present',
    line   => 'gdm-autologin auth  required    pam_unix_cred.so.1',
  }
  file_line { 'pam_allow.so.1':
    path   => '/etc/pam.conf',
    ensure => 'present',
    line   => 'gdm-autologin auth  sufficient  pam_allow.so.1',
  }

  file { '/home/metro':
    ensure => directory,
    owner  => 'metro',
    group  => 'nobody',
  }
  file { '/home/metro/sistema':
    ensure       => directory,
    owner        => 'metro',
    group        => 'nobody',
    sourceselect => all,
    source       => ["puppet:///data/tce_estacion/nodes/${::hostname}/home/metro/sistema",
                     'puppet:///data/tce_estacion/common/home/metro/sistema'],
    recurse      => remote,
    replace      => false,
    require      => File_line['auto_home'],
  }
  file { '/home/metro/.cshrc':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => 'puppet:///data/tce_estacion/common/home/metro/cshrc',
    mode   => '0644',
  }
  file { '/home/metro/.login':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => "puppet:///data/tce_estacion/common/home/metro/${login_file}",
    mode   => '0777',
  }
  file { '/home/metro/.autoarranque':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => 'puppet:///data/tce_estacion/common/home/metro/autoarranque',
    mode   => '0777',
  }
  file { '/home/metro/.autostart':
    ensure => file,
    owner  => 'metro',
    group  => 'nobody',
    source => "puppet:///data/tce_estacion/common/home/metro/${autostart_file}",
    mode   => '0777',
  }
  file { '/home/metro/sun':
    ensure  => directory,
    owner   => 'metro',
    group   => 'nobody',
    source  => 'puppet:///data/tce_estacion/common/home/metro/sun',
    recurse => true,
    mode    => '0755',
  }
  if $nolic {
    file { '/home/metro/sun/control':
      ensure => link,
      target => 'control.nolic',
      force  => true,
    }
  }
  file { '/home/metro/sun/cancela':
    ensure => link,
    target => "cancela_${cancela}",
    force  => true,
  }
  file { '/home/metro/sun/router':
    ensure => link,
    target => 'router.Motif',
    force  => true,
  }
  file { '/home/metro/sun/s7_cancela':
    ensure => link,
    target => 'cancela_siemens',
    force  => true,
  }
  file { '/home/metro/sun/ventilacion':
    ensure => link,
    target => 'ventilacion.ORIG',
    force  => true,
  }
  file { '/home/metro/sistema/V1':
    ensure => link,
    target => '/home/metro/sistema/V',
  }
  file { '/home/metro/sistema/V2':
    ensure => link,
    target => '/home/metro/sistema/V',
  }
  file { '/home/metro/sistema/V3':
    ensure => link,
    target => '/home/metro/sistema/V',
  }

  file { '/etc/inet':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    source => "puppet:///data/tce_estacion/nodes/${::hostname}/etc/inet",
    recurse => remote,
    mode    => '0444',
  }
  file { '/usr/lib':
    ensure  => directory,
    owner   => 'root',
    group   => 'bin',
    source  => 'puppet:///data/tce_estacion/common/usr/lib',
    recurse => remote,
  }

  file { '/home/metro/ControlId':
    ensure => directory,
    owner  => 'metro',
    group  => 'nobody',
  } ->
  file { '/etc/dfs/dfstab':
    ensure  => file,
    content => "share -F nfs -o rw /home/metro/ControlId\n",
    mode    => '0644',
    owner   => 'root',
    group   => 'sys',
  } ->
  service { 'svc:/network/nfs/server:default':
    ensure => 'running',
    enable => true,
  }
  file { '/home/metro/ControlId/Listas':
    ensure => directory,
    owner  => 'metro',
    group  => 'nobody',
  }
  file { '/home/metro/ControlId/logs':
    ensure => directory,
    owner  => 'metro',
    group  => 'nobody',
  }
  file { '/home/metro/ControlId/scripts':
    ensure  => directory,
    owner   => 'metro',
    group   => 'nobody',
    source  => 'puppet:///data/tce_estacion/common/home/metro/ControlId/scripts',
    recurse => true,
    mode    => '0755',
  }

  class { 'ntp':
    service_name  => 'ntp4',
    config        => '/etc/inet/ntp.conf',
    package_name  => ['SUNWntp4r','SUNWntp4u'],
    servers       => ["router_${::hostname}"],
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
    source => 'puppet:///data/tce_estacion/common/usr/bin/distsh2',
    owner  => 'root',
    group  => 'root',
    mode   => '4555',
  }

  file_line { 'controlsico1':
    path   => '/etc/rpc',
    ensure => 'present',
    line   => 'controlsico1    805306368',
  }
  file_line { 'controlsico2':
    path   => '/etc/rpc',
    ensure => 'present',
    line   => 'controlsico2    805306369',
  }
  file { '/etc/hosts.equiv':
    ensure  => file,
    content => "+\n",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
  file { '/usr/local':
    ensure  => directory,
    source  => 'puppet:///data/tce_estacion/common/usr/local',
    recurse => remote,
  }
  file { '/usr/local/tce':
    ensure => directory,
    owner  => 'metro',
    group  => 'nobody',
  }
  file { '/usr/local/tce/tce':
    ensure  => file,
    owner   => 'metro',
    group   => 'nobody',
    source  => "puppet:///data/tce_estacion/nodes/${::hostname}/usr/local/tce/tce",
    replace => false,
  }
  file_line { 'autologin':
    path   => '/etc/inittab',
    ensure => 'present',
    line   => 'co:234:respawn:/home/metro/sun/autologin >/dev/null 2>&1 </dev/null',
  }

  file { '/home/metro/Dtwm':
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/home/metro/Dtwm',
    owner  => 'root',
    group  => 'nobody',
  }

  file_line { 'default cron path':
    path   => '/etc/default/cron',
    ensure => 'present',
    line   => 'PATH=/opt/csw/bin:/usr/bin',
    match  => '^.?PATH.*$',
  }
  file_line { 'default cron supath':
    path   => '/etc/default/cron',
    ensure => 'present',
    line   => 'SUPATH=/opt/csw/bin:/usr/sbin:/usr/bin',
    match  => '^.?SUPATH.*$',
  } ~>
  service { 'svc:/system/cron:default':
    ensure => 'running',
    enable => true,
  }

  file_line { 'default path':
    path   => '/etc/default/login',
    ensure => 'present',
    line   => 'PATH=/opt/csw/bin:/usr/bin',
    match  => '^.?PATH.*$',
  }
  file_line { 'default supath':
    path   => '/etc/default/login',
    ensure => 'present',
    line   => 'SUPATH=/opt/csw/bin:/usr/sbin:/usr/bin',
    match  => '^.?SUPATH.*$',
  }

  file_line { 'default manpath':
    path   => '/etc/profile',
    ensure => 'present',
    line   => 'MANPATH="/opt/csw/share/man:/usr/share/man"',
    match  => '^MANPATH.*$',
  } ->
  file_line { 'export manpath':
    path   => '/etc/profile',
    ensure => 'present',
    line   => 'export MANPATH',
    after  => '^MANPATH.*$',
  }
  file_line { 'delete backspace':
    path   => '/etc/profile',
    ensure => 'present',
    line   => 'stty erase',
  }
  file_line { 'sound permissions':
    path   => '/etc/profile',
    ensure => 'absent',
    line   => 'chmod 666 /devices/pseudo/oss_sadasupport*',
  }
  file_line { 'mirror pkgutil':
    path   => '/etc/opt/csw/pkgutil.conf',
    ensure => 'present',
    line   => 'mirror=http://16.0.96.20/repo/opencsw/testing',
    match  => '^.?mirror.*$',
  } ->
  file_line { 'proxy pkgutil':
    path   => '/etc/opt/csw/pkgutil.conf',
    ensure => 'present',
    line   => 'wgetopts=-nv',
    match  => '^.?wgetopts.*$',
  } ->
  package { 'CSWsocat':
    ensure   => present,
    provider => 'pkgutil',
  } ->
  package { ['CSWcoreutils','CSWvim','CSWtop','CSWgtar','CSWfindutils','CSWgawk','CSWggrep','CSWgsed'] :
    ensure   => present,
    provider => 'pkgutil',
  } ->
  file { '/opt/csw/bin/locate':
    ensure => 'link',
    target => '/opt/csw/bin/glocate',
  } ->
  file { '/opt/csw/bin/updatedb':
    ensure => 'link',
    target => '/opt/csw/bin/gupdatedb',
  }
  package { 'CSWexpect' :
    ensure   => present,
    provider => 'pkgutil',
  }
  package { 'CSWbash' :
    ensure   => present,
    provider => 'pkgutil',
  }

  file { '/usr/bin/check_mon.sh' :
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/usr/bin/check_mon.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'bin',
  }
  file { '/usr/bin/check_controlnow.sh' :
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/usr/bin/check_controlnow.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'bin',
  }
  file { '/usr/bin/check_routernow.sh' :
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/usr/bin/check_routernow.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'bin',
  }
  file { '/usr/bin/check_discos.sh' :
    ensure => present,
    source => 'puppet:///data/tce_estacion/common/usr/bin/check_discos.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'bin',
  }
  file { '/etc/rc3.d/S99simon' :
    ensure  => present,
    content => "#/bin/sh\n/opt/csw/bin/socat TCP-LISTEN:5558,fork,reuseaddr,crlf SYSTEM:'/usr/bin/check_mon.sh' &\n",
    mode    => '0744',
    owner   => 'root',
    group   => 'other',
  }
  file { '/etc/rc3.d/S98soundperms' :
    ensure  => present,
    content => "#/bin/sh\n/usr/bin/chmod 666 /devices/pseudo/oss_sadasupport*\n",
    mode    => '0744',
    owner   => 'root',
    group   => 'other',
  }

  exec { '/usr/bin/rm /etc/dhcp.*' :
    onlyif => '/usr/bin/ls /etc/dhcp.*',
  }

  file { '/etc/defaultrouter' :
    ensure  => present,
    content => "router_${::hostname}\n",
  }

  cron { 'reboot' :
    command => '/usr/sbin/sync; /usr/sbin/reboot -q',
    user    => root,
    hour    => 4,
    minute  => 30,
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
    source => "puppet:///data/tce_estacion/nodes/${::hostname}/var/spool/cron/crontabs/metro",
    mode   => '0400',
  }
  file { '/etc/init.d/logclean':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///data/tce_estacion/common/etc/init.d/logclean',
  }
  file {'/etc/rc2.d/S02logclean':
    ensure => link,
    target => '/etc/init.d/logclean',
  }
  file { '/etc/init.d/logclean_metro':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///data/tce_estacion/common/etc/init.d/logclean_metro',
  }
  file {'/etc/rc2.d/S03logclean_metro':
    ensure => link,
    target => '/etc/init.d/logclean_metro',
  }
  file { '/etc/init.d/logclean_ppp':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///data/tce_estacion/common/etc/init.d/logclean_ppp',
  }
  file {'/etc/rc2.d/S04logclean_ppp':
    ensure => link,
    target => '/etc/init.d/logclean_ppp',
  }

  file {'/etc/inet/netmasks':
    ensure  => present,
    content => "${network} 255.255.255.0\n",
    owner   => 'root',
    group   => 'sys',
    mode    => '0444',
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
    show_diff      => true,
  }

  if $mbt {
    file {'/etc/ppp/ifconfig':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => "#!/sbin/sh\n /usr/local/bin/monitorppp 10 mbt-ppp '/usr/bin/pppd /dev/ttys09 9600 file /etc/ppp/peers/mbt-ppp' &\n",
    }
    file {'/etc/ppp/peers/mbt-ppp':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///data/tce_estacion/common/etc/ppp/peers/mbt-ppp',
    }
  }
}
