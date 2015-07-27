# == Define cfn_resource_bridge::custom_resource
#
# Installs a config file and the action script for a custom resource
# which is implemented on top of the AWS cfn-resource-bridge framework.
# See https://github.com/aws/aws-cfn-resource-bridge for more details.
#
#  * `queue_url`
#    The URL of the queue to pull messages from.
#
#  * `resource_type`
#    The custom resource type.
#
#  * `default_action`
#    The default action to perform when a message is received.
#    If `default_action` is not specified, then all
#    `{create,delete,update}_action` **must** be specified.
#
#  * `create_action`
#    The action to perform when a Create message is received.
#    If specified, gets called rather then the `default_action`
#    when a `Create` message is received.
#
#  * `delete_action`
#    The action to perform when a Delete message is received.
#    If specified, gets called rather then the `default_action`
#    when a `Delete` message is received.
#
#  * `update_action`
#    The action to perform when a Update message is received.
#    If specified, gets called rather then the `default_action`
#    when an `Update` message is received.
#
#  * `timeout`
#    The default timeout for messages taken from the queue.
#
#  * `create_timeout`
#    The message timeout for create actions.
#
#  * `delete_timeout`
#    The message timeout for delete actions.
#
#  * `update_timeout`
#    The message timeout for update actions.
#
#  * `flatten`
#    Flatten resource properties in environment variables (true by default).
#
#  * `service_token`
#    Optional service token for the event.
#
#  * `region`
#    The AWS region only required if it can't be determined from the queue URL.
#
define cfn_resource_bridge::custom_resource (
  $queue_url,
  $resource_type,
  $default_action = undef,
  $create_action  = undef,
  $delete_action  = undef,
  $update_action  = undef,
  $timeout        = undef,
  $create_timeout = undef,
  $delete_timeout = undef,
  $update_timeout = undef,
  $flatten        = true,
  $service_token  = undef,
  $region         = undef,
) {
  include cfn_resource_bridge

  validate_string($queue_url)
  validate_string($resource_type)
  validate_bool($flatten)

  if $default_action {
    # Specific actions can be overriden
    validate_absolute_path($default_action)
    if $create_action {
      validate_absolute_path($create_action)
    }
    if $delete_action {
      validate_absolute_path($delete_action)
    }
    if $update_action {
      validate_absolute_path($update_action)
    }
  } else {
    # If a default action is not defined, all other actions must be defined
    validate_absolute_path($create_action)
    validate_absolute_path($delete_action)
    validate_absolute_path($update_action)
  }

  if $timeout {
    validate_integer($timeout)
  }

  file { "${::cfn_resource_bridge::bridge_dir}/${name}.conf":
    ensure  => file,
    mode    => '0644',
    content => template('cfn_resource_bridge/bridge.conf.erb'),
  }
}
