# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: plugins
#
# Copyright 2014, Rackspace
#

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
