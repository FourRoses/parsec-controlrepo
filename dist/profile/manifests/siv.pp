class profile::siv {
  include metro::xsession
  include metro::xresources
  include metro::misc::xlinks
  include metro::sico::keys

  class {'metro::sico': } ->
  class {'metro::siv::client': }

}
