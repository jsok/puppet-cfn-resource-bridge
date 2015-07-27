[![Puppet Forge](http://img.shields.io/puppetforge/v/jsok/cfn_resource_bridge.svg)](https://forge.puppetlabs.com/jsok/cfn_resource_bridge)
[![Build Status](https://travis-ci.org/jsok/puppet-cfn-resource-bridge.svg?branch=master)](https://travis-ci.org/jsok/puppet-cfn-resource-bridge)

# puppet-cfn-resource-bridge

Puppet module to manage AWS
[aws-cfn-resource-bridge](https://github.com/aws/aws-cfn-resource-bridge).


## Support

This module is currently only tested on Ubuntu 14.04.

Installation requires the `pip` provider.

## Usage

This module includes a single class:

```puppet
include cfn_resource_bridge
```

This will install the resource bridge daemon as a system service.

## Custom Resources

A defined type is available for running custom resource actions.

```puppet
cfn_resource_bridge::custom_resource { 'eip-lookup':
    default_action => '/home/ec2-user/lookup-eip.py',
    resource_type  => 'Custom::EipLookup',
    queue_url      => 'https://your-sqs-queue-url-that-is-subscribed-to-the-sns-topic-in-the-service-token',
    timeout        => 60,
}
```

This can also be defined in Hiera:

```yaml
---

cfn_resource_bridge::custom_resources:
    eip-lookup:
        default_action: /home/ec2-user/lookup-eip.py
        resource_type: Custom::EipLookup
        queue_url: https://your-sqs-queue-url-that-is-subscribed-to-the-sns-topic-in-the-service-token
        timeout: 60
```
