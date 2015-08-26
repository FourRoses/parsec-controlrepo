class profile::sivestacion {
  class {'::networkdeb': } ->
  class {'::csh': } ->
  class {'::user::siv': } ->
  class {'::dkms': } ->
  class {'::metro::siv::estacion': } ->
  class {'::rlogin': } ->
  Class ['::profile::sivestacion']

  package {['libncurses5-dev','libssl-dev','libssl0.9.8']:
    ensure => installed,
  }
}
