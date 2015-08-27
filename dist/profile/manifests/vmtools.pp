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
    #class { '::vmwaretools':
    #  reposerver            => 'http://16.0.96.20:3142/',
    #  repopath              => 'packages.vmware.com/tools',
    #  just_prepend_repopath => true,
    #  tools_version         => "${::vmware}latest",
    #  autoupgrade           => true,
    #}
    include ::vmwaretools
  }
  if $vmtools_mode == 'openvmtools' {
    include ::openvmtools
  }

}
