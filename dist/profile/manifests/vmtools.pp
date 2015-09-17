class profile::vmtools {

  class { 'vmwaretools':
    version         => '9.0.10-1481436',
    working_dir     => '/tmp/vmwaretools',
    archive_url     => 'http://16.0.96.20/repo/vmwaretools',
    archive_md5     => '0a11d80baf58a1bd4df2e2a8c5b32a24',
    manage_dev_pkgs => false,
  }
}
