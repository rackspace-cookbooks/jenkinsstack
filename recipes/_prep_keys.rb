# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: _prep_master_for_slaves
#
# This utility recipe configures SSH keys for login from master to slave
# and it also places the newly created credentials (or existing ones) into
# node.run_state (for the private key) and
# node['jenkinsstack']['jenkins_slave_ssh_pubkey'] (for the public key).
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'

# inspired_from https://coderwall.com/p/-bohrw

# Install sshkey gem into chef
chef_gem 'sshkey'
require 'net/ssh'
require 'sshkey'

# Base location of ssh key
pkey = node['jenkins']['master']['home'] + '/.ssh/id_rsa'

# if the keys don't exist, create them using templates, and set variables
if !File.exist?(pkey)
  # Generate a keypair with Ruby
  sshkey = SSHKey.generate(
    type: 'RSA',
    comment: "#{node['jenkins']['master']['user']}@#{node['jenkins']['master']['host']}"
  )

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

  s_private_key = sshkey.private_key.to_s
  s_public_key  = sshkey.ssh_public_key.to_s

else # otherwise just set variables from existing key

  key = OpenSSL::PKey::RSA.new(File.read("#{pkey}"))
  s_private_key = key.to_pem
  s_public_key  = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"

end

# Save public key to chef-server as jenkins_slave_ssh_pubkey
ruby_block 'node-save-pubkey' do
  block do
    node.set['jenkinsstack']['jenkins_slave_ssh_pubkey'] = s_public_key
    node.save unless Chef::Config['solo']
  end
end

# Set the private key on the Jenkins executor in ruby, and at compile time.
node.run_state['jenkinsstack_private_key'] = s_private_key
ruby_block 'set private key' do
  block { node.run_state['jenkinsstack_private_key'] = s_private_key }
end
