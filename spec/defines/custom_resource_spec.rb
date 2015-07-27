require 'spec_helper'

describe 'cfn_resource_bridge::custom_resource', :type => :define do
  let(:title) { 'example' }

  context 'with all params' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'default_action' => '/path/to/action',
      'create_action' => '/path/to/create',
      'delete_action' => '/path/to/delete',
      'update_action' => '/path/to/update',
      'timeout' => 30,
      'create_timeout' => 30,
      'delete_timeout' => 30,
      'update_timeout' => 30,
      'flatten' => true,
      'service_token' => 'token',
      'region' => 'us-east-1',
    }}

    it { should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf').with_mode('0644') }
    it {
      should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf') \
        .with_content(/[#{title}]/) \
        .with_content(/^queue_url = https:\/\/queueurl$/) \
        .with_content(/^resource_type = Custom::Example$/) \
        .with_content(/^default_action = \/path\/to\/action$/)
        .with_content(/^create_action = \/path\/to\/create$/) \
        .with_content(/^delete_action = \/path\/to\/delete$/) \
        .with_content(/^update_action = \/path\/to\/update$/)
        .with_content(/^timeout = 30$/) \
        .with_content(/^create_timeout = 30$/) \
        .with_content(/^delete_timeout = 30$/) \
        .with_content(/^update_timeout = 30$/)
        .with_content(/^flatten = true$/) \
        .with_content(/^service_token = token$/) \
        .with_content(/^region = us-east-1$/) \
     }
  end

  context 'with default action' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'default_action' => '/path/to/action',
    }}

    it { should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf').with_mode('0644') }
    it {
      should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf') \
        .with_content(/[#{title}]/) \
        .with_content(/queue_url = https:\/\/queueurl/) \
        .with_content(/resource_type = Custom::Example/) \
        .with_content(/default_action = \/path\/to\/action/)
     }
  end

  context 'with all actions defined' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'create_action' => '/path/to/create',
      'delete_action' => '/path/to/delete',
      'update_action' => '/path/to/update',
    }}

    it {
      should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf') \
        .without_content(/default_action = /) \
        .with_content(/create_action = \/path\/to\/create/) \
        .with_content(/delete_action = \/path\/to\/delete/) \
        .with_content(/update_action = \/path\/to\/update/)
     }
  end

  context 'default action and delete action defined' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'default_action' => '/path/to/action',
      'delete_action' => '/path/to/delete',
    }}

    it {
      should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf') \
        .with_content(/^default_action = \/path\/to\/action$/) \
        .with_content(/^delete_action = \/path\/to\/delete$/)
     }
  end

  context 'with timeout' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'default_action' => '/path/to/action',
      'timeout' => 30,
    }}
    it {
      should contain_file('/etc/cfn-resource-bridge/bridge.d/example.conf') \
        .with_content(/^timeout = 30$/)
     }
  end

  # Error cases

  context 'no defined action defined' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
    }}
    it { is_expected.to raise_error(Puppet::Error) }
  end

  context 'incomplete actions defined' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'create_action' => '/path/to/create',
      'delete_action' => '/path/to/delete',
    }}
    it { is_expected.to raise_error(Puppet::Error) }
  end

  context 'with non-integer timeout' do
    let(:params) {{
      'queue_url' => 'https://queueurl',
      'resource_type' => 'Custom::Example',
      'default_action' => '/path/to/action',
      'timeout' => 'not-a-timeout',
    }}
    it { is_expected.to raise_error(Puppet::Error) }
  end

end
