class profile::poi (
  $apps,
) {

  class {'::snmp':
    agentaddress      => hiera('snmp::agentaddress'),
    views             => hiera('snmp::views'),
    com2sec           => hiera('snmp::com2sec'),
  }

  include ::interfaces
  include ::metro
  include ::xprintidle
  include ::incron
  include ::swaks
  include ::zenity
  include ::metro::misc::captura
  include ::metro::misc::fonts
  include ::metro::misc::bashprofile
  include ::metro::poi
  if $::hostname == 'poim3' {
    include metro::misc::compartido
  }
  if member($apps, 'ctc') {
    include profile::ctc
    include profile::ats
  }
  if member($apps, 'rctc') {
    include profile::rctc
  }
  if member($apps, 'igcamaras') {
    include profile::igcamaras
  }
  if member($apps, 'megafonia') {
    include profile::megafonia
  }
  if member($apps, 'siv') {
    include profile::siv
  }
  if member($apps, 'xpostit') {
    include profile::xpostit
  }
  if member($apps, 'enrutador') {
    include profile::enrutador
  }
  if member($apps, 'tn') {
    include profile::tn
  }
  if member($apps, 'sirei') {
    include profile::sirei
  }
  if member($apps, 'rt') {
    include profile::rt
  }
  if member($apps, 'ctcligero') {
    include profile::ctcligero
  }
  if member($apps, 'tce') {
    include profile::tce
  }
  if member($apps, 'isacd') {
    include profile::isacd
  }
#  if member($apps, 'ats') {
#    include profile::ats
#  }
  if member($apps, 'vncpogui') {
    include profile::vncpogui
  }
  if member($apps, 'herramienta') {
    include profile::herramienta
  }
  if member($apps, 'controlpantallas') {
    include metro::misc::controlpantallas
  }
}
