# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: ruby
#
# Copyright 2014, Rackspace
#

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

rbenv_ruby node['jenkinsstack']['server_ruby'] do
  global false
end

node['jenkinsstack']['ruby_gems'].each do |gem_name|
  rbenv_gem gem_name do
    ruby_version node['jenkinsstack']['server_ruby']
  end
end

# non login shells
file "#{node['jenkins']['master']['home']}/.bashrc" do
  content "rbenv shell #{node['jenkinsstack']['server_ruby']}"
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
end

# login shells
file "#{node['jenkins']['master']['home']}/.bash_profile" do
  content "rbenv shell #{node['jenkinsstack']['server_ruby']}"
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
end
