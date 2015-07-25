require 'spec_helper'

describe 'cfn_resource_bridge' do

  context "cfn_resource_bridge class without any parameters" do
    let(:params) {{ }}

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('cfn_resource_bridge::params') }
    it { is_expected.to contain_class('cfn_resource_bridge::install').that_comes_before('cfn_resource_bridge::config') }
    it { is_expected.to contain_class('cfn_resource_bridge::config') }
    it { is_expected.to contain_class('cfn_resource_bridge::service').that_subscribes_to('cfn_resource_bridge::config') }

    it { is_expected.to contain_service('cfn-resource-bridge').with_ensure('running').with_enable('true') }
    it { is_expected.to contain_package('cfn-resource-bridge').with_ensure('present').with_provider('pip') }

    it {
      is_expected.to contain_file('/etc/init/cfn-resource-bridge.conf')
         .with_mode('0444')
         .with_owner('root')
         .with_group('root')
    }

    it { is_expected.to contain_file('/etc/cfn-resource-bridge').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/cfn-resource-bridge/bridge.d').with_ensure('directory') }
  end

  context "cfn_resource_bridge class with custom package name and download url" do
    let(:params) {{
      'package_name' => 'package',
      'download_url' => 'http://example.com/package.tar.gz',
    }}
    it { is_expected.to contain_package('package').with_source('http://example.com/package.tar.gz') }
  end

  context "cfn_resource_bridge class with custom service name" do
    let(:params) {{ 'service_name' => 'service' }}
    it { is_expected.to contain_service('service') }
  end

  context "cfn_resource_bridge class with config dir" do
    let(:params) {{ 'config_dir' => '/etc/custom' }}
    it { is_expected.to contain_file('/etc/custom').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/custom/bridge.d').with_ensure('directory') }
  end
end
