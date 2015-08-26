class profile::tce_solo {
  include metro
  include metro::xsession
  include metro::xresources
  include metro::misc::xlinks
  include metro::misc::fonts
  include metro::sico::keys

  include zenity
  include incron
  include swaks

  include metro::misc::compruebalogin
  include metro::misc::finsesion

  class {'metro::misc::x11vnc_broker':
    port => '10001',
  }
  
  class {'metro::sico': } ->
  class {'metro::tce::client':
    monitor => '0',
    fixed   => true,
  }
}
