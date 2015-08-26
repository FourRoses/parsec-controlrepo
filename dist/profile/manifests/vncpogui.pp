class profile::vncpogui {
  include ::vncviewer
  class {'elotouch':
    monitor => hiera(metro::vncpogui::monitor)
  }
  include metro::vncpogui
}
