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

# Run critical recipe
include_recipe 'jenkins::master'

user node['jenkins']['master']['user'] do
  shell '/bin/bash'
  action :manage
end

# install plugins and theme
include_recipe 'jenkinsstack::plugins'

# prepare master for slaves
include_recipe 'jenkinsstack::_prep_keys'

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
