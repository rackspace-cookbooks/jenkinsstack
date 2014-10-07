# Encoding: utf-8

require_relative 'spec_helper'

describe 'jenkinsstack::master' do
  before { stub_resources }
  describe 'ubuntu' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:runit][:sv_bin] = '/usr/bin/sv'
        node.run_state[:jenkinsstack_private_key] = 'foo'
      end.converge(described_recipe)
    end

    it 'apt-get updates' do
      expect(chef_run).to execute_command 'apt-get update'.at_compile_time
    end

    it 'includes recipes' do
      expect(chef_run).to include_recipe('apt::default')
      expect(chef_run).to include_recipe('build-essential::default')
      expect(chef_run).to include_recipe('jenkins::java')
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
      ChefSpec::Runner.new do |node|
        node.set[:runit][:sv_bin] = '/usr/bin/sv'
        node.set[:jenkinsstack_private_key] = 'foo'
      end.converge(described_recipe)
    end

    it 'includes recipes' do
      expect(chef_run).to include_recipe('build-essential::default')
      expect(chef_run).to include_recipe('jenkins::java')
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
