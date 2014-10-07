# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

# Run base recipe (apt, java, various settings)
include_recipe 'jenkinsstack::_base'

# find master so we can get pubkey for ssh
include_recipe 'jenkinsstack::_find_master'
found_master = node.run_state['jenkinsstack_master']

jenkins_slave_ssh_pubkey = found_master &&
                           found_master['jenkinsstack'] &&
                           found_master['jenkinsstack']['jenkins_slave_ssh_pubkey']

Chef::Log.warn("Did not find a master or master's public SSH key needed to authenticate") unless jenkins_slave_ssh_pubkey

# Store public key on disk
template "#{node['jenkins']['master']['home']}/.ssh/authorized_keys" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  variables(
    ssh_public_key: jenkins_slave_ssh_pubkey
  )
  mode 00644
  action :create # create every time. master key could change.
  only_if { jenkins_slave_ssh_pubkey }
end

# SSH slaves!
tag('jenkinsstack')
tag('jenkinsstack_slave')
