class profile::foreman {
  class {'::foreman':
    passenger => false,
  }
}
