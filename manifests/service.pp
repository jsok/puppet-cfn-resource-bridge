# == Class cfn_resource_bridge::service
#
# Ensures the daemon is running.
#
class cfn_resource_bridge::service {
  service { $::cfn_resource_bridge::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
