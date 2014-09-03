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

# this should happen at compile time, or the upstream jenkins cookbook's ruby
# code will fail to find these keys we setup
prepare_keys = ruby_block 'prepare_keys' do # ~FC014
  block do

    # Create the Jenkins user
    u = Chef::Resource::User.new(node['jenkins']['master']['user'], run_context)
    u.home node['jenkins']['master']['home']
    u.shell '/bin/bash'
    u.run_action :create

    # Create the Jenkins group
    g = Chef::Resource::Group.new(node['jenkins']['master']['group'], run_context)
    g.members node['jenkins']['master']['user']
    g.run_action :create

    # create .ssh dir for jenkins
    d = Chef::Resource::Directory.new("#{node['jenkins']['master']['home']}/.ssh", run_context)
    d.owner node['jenkins']['master']['user']
    d.group node['jenkins']['master']['group']
    d.mode 00700
    d.recursive true
    d.run_action :create

    if File.exist?(pkey)
      # just set variables from existing keys
      key = OpenSSL::PKey::RSA.new(File.read(pkey))
      s_private_key = key.to_pem

      # needed every run for creating credentials object in jenkins
      node.run_state['jenkinsstack_private_key'] = s_private_key

      # update pub key as well
      s_public_key  = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
      node.set['jenkinsstack']['jenkins_slave_ssh_pubkey'] = s_public_key
      node.save unless Chef::Config['solo']

      # only populate if they already existed (else first run breaks)
      node.run_state[:jenkins_private_key_path] = pkey
      node.run_state[:jenkins_private_key] = s_private_key
    else
      # Generate a keypair with Ruby
      sshkey = SSHKey.generate(
        type: 'RSA',
        comment: "#{node['jenkins']['master']['user']}@#{node['jenkins']['master']['host']}"
      )
      key = OpenSSL::PKey::RSA.new(sshkey.private_key)

      # save for using in our ssh configuration for slaves
      s_public_key  = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
      s_private_key = key.to_pem

      node.set['jenkinsstack']['jenkins_slave_ssh_pubkey'] = s_public_key
      node.save unless Chef::Config['solo']

      # needed every run for creating credentials object in jenkins
      node.run_state['jenkinsstack_private_key'] = s_private_key

      # first time when no file exists, just create them from templates
      r = Chef::Resource::Template.new(pkey, run_context)
      r.path pkey
      r.owner node['jenkins']['master']['user']
      r.group node['jenkins']['master']['group']
      r.cookbook 'jenkinsstack'
      r.source 'id_rsa.erb'
      r.variables  ssh_private_key: sshkey.private_key
      r.mode 00600
      r.run_action :create

      s = Chef::Resource::Template.new("#{pkey}.pub", run_context)
      s.path "#{pkey}.pub"
      s.owner node['jenkins']['master']['user']
      s.group node['jenkins']['master']['group']
      s.cookbook 'jenkinsstack'
      s.source 'id_rsa.pub.erb'
      s.variables ssh_public_key: sshkey.ssh_public_key
      s.mode 00644
      s.run_action :create
    end # end file exists
  end
  action :nothing
end

# now, do it now!
prepare_keys.run_action(:run)
