# == Class cfn_resource_bridge::install
#
# Installs using pip, will fail if not available.
#
class cfn_resource_bridge::install {
  package { $::cfn_resource_bridge::package_name:
    ensure   => present,
    source   => $::cfn_resource_bridge::download_url,
    provider => pip
  }
}
