class role::tce inherits role {
  include profile::x11
  include profile::vncserver
  include profile::tce_solo
}
