# == Class cfn_resource_bridge::config
#
# Creates configuration file for the daemon and installs an upstart script.
#
class cfn_resource_bridge::config {
  file { '/etc/init/cfn-resource-bridge.conf':
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    content => template('cfn_resource_bridge/cfn-resource-bridge.upstart.erb'),
  }

  file { $::cfn_resource_bridge::config_dir:
    ensure => directory,
  } ->
  file { $::cfn_resource_bridge::bridge_dir:
    ensure => directory,
  }
}
