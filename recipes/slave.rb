# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

# Run base recipe (apt, java, various settings)
include_recipe 'jenkinsstack::_base'

# Create the Jenkins user
user node['jenkins']['master']['user'] do
  home node['jenkins']['master']['home']
end

# Create the Jenkins group
group node['jenkins']['master']['group'] do
  members node['jenkins']['master']['user']
end

# Create the home directory
directory node['jenkins']['master']['home'] do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0755'
  recursive true
end

# Create ~/.ssh directory
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 00700
end

include_recipe 'jenkinsstack::_find_master'
found_master = node.run_state['jenkinsstack_master']

no_master = found_master.nil? || found_master.keys.empty?
Chef::Log.warn("Did not find a master jenkins node") if no_master

# find public key
jenkins_slave_ssh_pubkey = found_master['jenkinsstack']['jenkins_slave_ssh_pubkey']
no_key = jenkins_slave_ssh_pubkey.nil? || jenkins_slave_ssh_pubkey.empty?
Chef::Log.warn("Did not find a public SSH key needed for master #{found_master} to authenticate") if no_key && !no_master

# Store public key on disk
authorized_keys = node['jenkins']['master']['home'] + '/.ssh/authorized_keys'
template authorized_keys do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  variables(
    ssh_public_key: jenkins_slave_ssh_pubkey
  )
  mode 00644
  action :create # create every time. master key could change.
  only_if { !jenkins_slave_ssh_pubkey.nil? && !jenkins_slave_ssh_pubkey.empty?}
end

# SSH slaves!
tag('jenkinsstack_slave')
