# Encoding: utf-8

require_relative 'spec_helper'

describe 'jenkinsstack::master' do
  before { stub_resources }
  describe 'ubuntu' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

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
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

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
