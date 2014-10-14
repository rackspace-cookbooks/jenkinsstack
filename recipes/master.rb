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

# Pin to 1.555 until JENKINS-22346 is fixed
# https://issues.jenkins-ci.org/browse/JENKINS-22346
node.override['jenkins']['master']['version'] = '1.555'
node.override['jenkins']['master']['runit']['sv_timeout'] = 45
include_recipe 'jenkins::master'

# prepare keys for master and slaves, set handy variables
include_recipe 'jenkinsstack::_prep_keys'
s_private_key = node.run_state['jenkinsstack_private_key']
s_public_key  = node['jenkinsstack']['jenkins_slave_ssh_pubkey']

# Create jenkins auth user, this enables auth for further actions
jenkins_user 'chef' do
  public_keys [s_public_key]
end

# install plugins and theme
include_recipe 'jenkinsstack::_plugins'

# create jenkins credential, useful to ssh to slaves
jenkins_private_key_credentials node['jenkins']['master']['user'] do
  username node['jenkins']['master']['user']
  description 'Jenkins Slave SSH Key'
  private_key s_private_key
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
    executors   node['jenkinsstack']['slave']['executors']

    # SSH specific attributes
    host        slave_ip # or 'slave.example.org'
    user        node['jenkins']['master']['user']
    credentials node['jenkins']['master']['user']
  end
end

# trivial protection for the jenkins web interface, wrapper/app cookbooks
# should be disabling this and doing their own thing
if node['jenkinsstack']['nginx_proxy']
  include_recipe 'jenkinsstack::_nginx'
end

# Add ELK stack logging, if we are logging to elkstack
fail "logging was false" unless node.deep_fetch('platformstack', 'elkstack_logging', 'enabled')
if node.deep_fetch('platformstack', 'elkstack_logging', 'enabled')
  # ensure platformstack's logging is already done
  include_recipe 'platformstack::logging'

  # add one more config for our additional logs
  logstash_commons_config 'input_jenkins' do
    template_source_file 'input_jenkins.conf.erb'
    template_source_cookbook 'jenkinsstack'
    variables(path: node['jenkins']['master']['home'])
  end
end

tag('jenkinsstack')
tag('jenkinsstack_master')
