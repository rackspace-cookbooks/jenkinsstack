# Encoding: utf-8

require_relative 'spec_helper'

describe 'jenkinsstack::master' do
  before { stub_resources }
  describe 'ubuntu' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        # Setup system attributes
        node.set['memory']['total'] = 2048
        node.set['cpu']['total'] = 2

        node.set[:runit][:sv_bin] = '/usr/bin/sv'
        node.run_state['jenkinsstack_private_key'] = 'foo'
        # no need to converge elkstack agent for this
        node.set['platformstack']['elkstack_logging']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'includes recipes' do
      expect(chef_run).to include_recipe('apt::default')
      expect(chef_run).to include_recipe('build-essential::default')
      expect(chef_run).to include_recipe('jenkins::master')
    end

    it 'installs git' do
      expect(chef_run).to install_package('git')
    end

    it 'creates template file' do
      expect(chef_run).to render_file('/var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml').with_content('canon-jenkins')
    end
  end

  describe 'centos' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: '6.5') do |node|
        # Setup system attributes
        node.set['memory']['total'] = 2048
        node.set['cpu']['total'] = 2

        node.set[:runit][:sv_bin] = '/usr/bin/sv'
        node.run_state['jenkinsstack_private_key'] = 'foo'
        # no need to converge elkstack agent for this
        node.set['platformstack']['elkstack_logging']['enabled'] = false
      end.converge(described_recipe)
    end

    it 'includes recipes' do
      expect(chef_run).to include_recipe('build-essential::default')
      expect(chef_run).to include_recipe('jenkins::master')
    end

    it 'installs git' do
      expect(chef_run).to install_package('git')
    end

    it 'creates template file' do
      expect(chef_run).to render_file('/var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml').with_content('canon-jenkins')
    end
  end
end
