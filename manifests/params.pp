# == Class cfn_resource_bridge::params
#
class cfn_resource_bridge::params {
  $config_dir   = '/etc/cfn-resource-bridge'
  $download_url = 'https://github.com/aws/aws-cfn-resource-bridge/tarball/master'
  $package_name = 'cfn-resource-bridge'
  $service_name = 'cfn-resource-bridge'
}
