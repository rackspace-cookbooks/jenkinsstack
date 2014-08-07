# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: _base
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

include_recipe 'jenkins::java'

## Hate to do these creates here, but we want them to exist before installing
## Jenkins as the keys created are used on jenkins setup
# Create the Jenkins user
user node['jenkins']['master']['user'] do
  home node['jenkins']['master']['home']
end

# Create the Jenkins group
group node['jenkins']['master']['group'] do
  members node['jenkins']['master']['user']
end

# create .ssh dir for jenkins
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 00700
  recursive true
end
