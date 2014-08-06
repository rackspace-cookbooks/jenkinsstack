# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: _prep_master_for_slaves
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'

# inspired_from https://coderwall.com/p/-bohrw

# Install sshkey gem into chef
chef_gem 'sshkey'

# Base location of ssh key
pkey = node['jenkins']['master']['home'] + '/.ssh/id_rsa'

# Generate a keypair with Ruby
require 'sshkey'
sshkey = SSHKey.generate(
  type: 'RSA',
  comment: "#{node['jenkins']['master']['user']}@#{node['jenkins']['master']['host']}"
)

# Create ~/.ssh directory
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 00700
end

# Store private key on disk
template pkey do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  source 'id_rsa.erb'
  variables(
    ssh_private_key: sshkey.private_key
  )
  mode 00600
  action :create_if_missing
end

# Store public key on disk
template "#{pkey}.pub" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  source 'id_rsa.pub.erb'
  variables(
    ssh_public_key: sshkey.ssh_public_key
  )
  mode 00644
  action :create_if_missing
end

# Save public key to chef-server as jenkins_pubkey
ruby_block 'node-save-pubkey' do
  block do
    node.set_unless['jenkinsstack']['jenkins_slave_ssh_pubkey'] = File.read("#{pkey}.pub")
    node.save unless Chef::Config['solo']
  end
end

# Create private key credentials
jenkins_private_key_credentials 'jenkins_slave' do
  description 'Jenkins Slave'
  private_key sshkey.private_key
end
