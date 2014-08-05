# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: plugins
#
# Copyright 2014, Rackspace
#

# Install Jenkins plugins
node['rax']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin
end
