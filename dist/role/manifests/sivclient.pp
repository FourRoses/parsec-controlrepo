class role::sivclient {
  include profile::base
  include profile::x11
  include profile::vncserver
  include profile::siv_solo
}
