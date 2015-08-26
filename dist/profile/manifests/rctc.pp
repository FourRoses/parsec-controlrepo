class profile::rctc {
  include metro::xsession_replica
  include metro::xresources
  include metro::misc::xlinks
  include audio
  class { 'metro::ctc':
    xsession => '.xsession_replica',
  }
}
