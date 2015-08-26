class profile::openbox {
  class {'::x11':
    wm => 'openbox',
  }
}
