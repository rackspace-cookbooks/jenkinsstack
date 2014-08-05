# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

# for package data to be updated earlier
node.set['apt']['compile_time_update'] = true

tag('jenkinsstack_slave')
