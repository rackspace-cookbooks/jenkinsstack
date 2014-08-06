# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

node.override['apt']['compile_time_update'] = true
include_recipe 'apt'

node.override['build-essential']['compile_time'] = true
include_recipe 'build-essential'

tag('jenkinsstack_slave')
