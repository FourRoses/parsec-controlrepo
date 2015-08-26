class profile::ctc {
  include metro::xsession
  include metro::xresources
  include metro::misc::xlinks
  include ::audio
  class { 'metro::ctc': }
}
