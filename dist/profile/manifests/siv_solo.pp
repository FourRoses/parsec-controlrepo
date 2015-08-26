class profile::siv_solo {
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
    port => '10002',
  }
  
  class {'metro::sico': } ->
  class {'metro::siv::client':
    fixed   => true,
  }
}
