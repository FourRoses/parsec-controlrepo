class profile::vmtools {

  $vmtools_mode = $::operatingsystem ? {
    'Ubuntu' => $::lsbdistrelease ? {
      '10.04' => $::rol ? {
        'siv'   => 'vmwaretools', #workaround because no vmwaretools for 10.04 siv $::kernelrelease (2.6.32-40-generic) version.
        default => 'vmwaretools',
      },
      default => 'openvmtools',
    },
    'CentOS' => $::lsbdistrelease ? {
      /5.*/     => 'vmwaretools',
      /6.*/     => 'vmwaretools',
      default => 'openvmtools',
    },
  default => 'openvmtools',
  }


  if $vmtools_mode == 'vmwaretools' {
    class { 'vmwaretools':
      version         => '9.0.10-1481436',
      working_dir     => '/tmp/vmwaretools',
      archive_url     => 'http://16.0.96.20/repo/vmwaretools',
      archive_md5     => '0a11d80baf58a1bd4df2e2a8c5b32a24',
      manage_dev_pkgs => false,
    }
  }
  if $vmtools_mode == 'openvmtools' {
    include ::openvmtools
  }

}
