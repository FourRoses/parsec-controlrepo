class profile::ats {
  realize(Yum::Repo['centos-updates'])
  include metro::misc::botones
  include ::firefox
  include metro::misc::rkiosk
  include ::xdotool
  include ::java
  #class {'metro::enrutador':
  #  autostart => false,
  #  monitor   => false,
  #}
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

