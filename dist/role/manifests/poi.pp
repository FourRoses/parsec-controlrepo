class role::poi {
  include profile::base
  include profile::x11::nvidia
  include profile::vncserver
  include profile::poi
}
