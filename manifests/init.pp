# Class: cfn_resource_bridge
# ===========================
#
# Installs the cfn-resource-bridge daemon.
#
# Parameters
# ----------
#
# * `config_dir`
#   Path where the configuration files are stored.
#   Defaults to /etc/cfn-resource-bridge
#
# * `download_url`
#   URL to get the Python package from.
#   Defaults to the latest master tarball from AWS GitHub account.
#
# * `custom_resources`
#   Hash of custom resources to realise.
#
class cfn_resource_bridge (
  $config_dir       = $cfn_resource_bridge::params::config_dir,
  $download_url     = $cfn_resource_bridge::params::download_url,
  $package_name     = $cfn_resource_bridge::params::package_name,
  $service_name     = $cfn_resource_bridge::params::service_name,
  $custom_resources = {},
) inherits cfn_resource_bridge::params {
  $bridge_dir  = "${config_dir}/bridge.d"

  class { '::cfn_resource_bridge::install': } ->
  class { '::cfn_resource_bridge::config': } ~>
  class { '::cfn_resource_bridge::service': } ->
  Class['::cfn_resource_bridge']

  create_resources(::cfn_resource_bridge::custom_resource, $custom_resources)
  Cfn_resource_bridge::Custom_resource <||> ~> Service['cfn-resource-bridge']
}
