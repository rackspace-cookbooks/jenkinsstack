# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: master
#
# Copyright 2014, Rackspace
#

# sweet!
include_recipe 'chef-sugar'

# Run base recipe (apt, java, various settings)
include_recipe 'jenkinsstack::_base'

# prepare keys for master and slaves, set handy variables
include_recipe 'jenkinsstack::_prep_keys'
s_private_key = node.run_state['jenkinsstack_private_key']
s_public_key  = node['jenkinsstack']['jenkins_slave_ssh_pubkey']

# Pin to 1.555 until JENKINS-22346 is fixed
# https://issues.jenkins-ci.org/browse/JENKINS-22346
node.override['jenkins']['master']['version'] = '1.555'
include_recipe 'jenkins::master'

user node['jenkins']['master']['user'] do
  shell '/bin/bash'
  action :manage
end

# install plugins and theme
include_recipe 'jenkinsstack::plugins'

# create jenkins credential
jenkins_private_key_credentials node['jenkins']['master']['user'] do
  username node['jenkins']['master']['user']
  description 'Jenkins Slave SSH Key'
  private_key s_private_key
end

# Create jenkins auth user
jenkins_user 'chef' do
  public_keys [s_public_key]
end

# find any existing slaves
include_recipe 'jenkinsstack::_find_slaves'
slaves = node.deep_fetch('jenkinsstack', 'slaves')
if slaves.nil?
  slaves = {} # default it, so we don't have to write the next block indented
end

# define the slaves launched via SSH
slaves.each do |slave_name, slave_ip|
  jenkins_ssh_slave slave_name do
    description 'Run builds as slaves'
    remote_fs   '/var/lib/jenkins'
    labels      ['executor']

    # SSH specific attributes
    host        slave_ip # or 'slave.example.org'
    user        node['jenkins']['master']['user']
    credentials node['jenkins']['master']['user']
  end
end

tag('jenkinsstack_master')
