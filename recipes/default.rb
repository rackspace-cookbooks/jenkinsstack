# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

#jenkins settings
node.default['jenkins']['server']['install_method'] = 'war'
node.default['jenkins']['http_proxy']['www_redirect'] = 'enable'
node.default['jenkins']['server']['host'] = 'jenkins.example.com'
node.default['jenkins']['http_proxy']['host_name'] = 'jenkins.example.com'

# The following two attributes need to match.  The first is the jenkins.war version to download from
# http://mirrors.jenkins-ci.org/war/ and the second is the sha256 hash of the file to prevent download
# of the war file on every Chef run.
node.default['jenkins']['server']['version']      = '1.571'
node.default['jenkins']['server']['war_checksum'] = '312d0a3fa6a394e2c9e6d31042b7db70674eb3abb3a431a41390fef97db0f9f4'

node.default['jenkins']['server']['jvm_options'] = '-XX:MaxPermSize=512m'

node.default['apache2']['listen_ports'] = ['81']
node.default['nginx']['default_site_enabled'] = false
node.default['mysql']['tunable']['max_connections'] = '2000'

node.default['rackspace_apache']['config']['listen_ports'] = ['81']
node.default['rackspace_nginx']['config']['default_site_enabled'] = false
node.default['rackspace_mysql']['config']['mysqld']['max_connections']['value'] = '2000'
node.default['build-essential']['compile_time'] = true


node.default['jenkins']['server']['plugins'] = [
  'subversion',
  'ws-cleanup',
  'disk-usage',
  'copyartifact',
  'artifactory',
  'email-ext',
  'javadoc',
  'jobConfigHistory',
  'jobcopy-builder',
  'mailer',
  'publish-over-ssh',
  'ssh-credentials',
  'token-macro',
  'scp',
  'cloudbees-folder',
  'maven-plugin'
]

critical_recipes = [
  'build-essential',
  'jenkins::server',
  'jenkins::proxy'
]

#Run critical recipes
critical_recipes.each do | recipe |
  include_recipe recipe
end

user "#{node['jenkins']['server']['user']}" do
  shell '/bin/bash'
  action :manage
end

# Do we need these? %w{ant1.7 tig maven subversion maven2}
#package_list = %w(git build-essential)
#package_list.each do |thing|
#  package thing do
#    action :install
#  end
#end

execute 'group recursive jenkins dir' do
  command "chmod -Rf g+rwx #{node['jenkins']['server']['home']}/jobs"
  action :run
end
