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
append_if_no_line 'add rbenv to bashrc' do
  path "#{node['jenkins']['master']['home']}/.bashrc"
  line "rbenv shell #{node['jenkinsstack']['server_ruby']}"
end

# login shells
append_if_no_line 'add rbenv to bash profile' do
  path "#{node['jenkins']['master']['home']}/.bash_profile"
  line "rbenv shell #{node['jenkinsstack']['server_ruby']}"
end
