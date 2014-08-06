# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: master
#
# Copyright 2014, Rackspace
#

node.override['apt']['compile_time_update'] = true
include_recipe 'apt'

node.override['build-essential']['compile_time'] = true
include_recipe 'build-essential'

# other settings
node.default['nginx']['default_site_enabled'] = false

# jenkins settings
node.default['jenkins']['master']['jvm_options'] = '-XX:MaxPermSize=512m'
node.default['jenkins']['master']['listen_address'] = '0.0.0.0'

# The following attributes need to match.  The first is the jenkins.war version to download from
# http://mirrors.jenkins-ci.org/war/ and the second is the sha256 hash of the file to prevent download
# of the war file on every Chef run.
# comment out old version --
# node.default['jenkins']['master']['version']      = '1.571'
# node.default['jenkins']['master']['checksum'] = '312d0a3fa6a394e2c9e6d31042b7db70674eb3abb3a431a41390fef97db0f9f4'
node.default['jenkins']['master']['install_method'] = 'war'

node['jenkinsstack']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

critical_recipes = [
  'jenkins::java',
  'jenkins::master'
]

# Run critical recipes
critical_recipes.each do | recipe |
  include_recipe recipe
end

user node['jenkins']['master']['user'] do
  shell '/bin/bash'
  action :manage
end

node.default['jenkinsstack']['plugins'].each do |plugin_name|
  jenkins_plugin plugin_name do
    notifies :restart, 'service[jenkins]', :delayed
  end
end

# Install Rackspace Canon Jenkins Theme
template File.join(node['jenkins']['master']['home'], 'org.codefirst.SimpleThemeDecorator.xml') do
  source 'org.codefirst.SimpleThemeDecorator.xml'
  mode 0644
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  notifies :restart, 'service[jenkins]'
  action :create_if_missing
  only_if { node['jenkinsstack']['rax_theme'] }
end

tag('jenkinsstack_master')
