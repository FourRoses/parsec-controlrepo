class profile::pulp {
  class {'::pulp::admin': }
  class {'::pulp::server': }
}
