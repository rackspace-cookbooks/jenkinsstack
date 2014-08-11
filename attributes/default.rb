# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

default['jenkinsstack']['proxy_password'] = nil
default['jenkinsstack']['nginx_proxy'] = true
default['jenkinsstack']['rax_theme'] = true
default['jenkinsstack']['plugins'] = [
  'credentials',
  'ssh-credentials',
  'scm-api',
  'multiple-scms',
  'git-client',
  'git',
  'github-api',
  'github',
  'ghprb',
  'jquery',
  'backup',
  'mailer',
  'javadoc',
  'maven-plugin',
  'violations',
  'dashboard-view',
  'buildgraph-view',
  'parameterized-trigger',
  'build-pipeline-plugin',
  'jclouds-jenkins',
  'simple-theme-plugin'
]

default['jenkinsstack']['server_ruby'] = '1.9.3-p484'
default['jenkinsstack']['ruby_gems'] = [
  'bundler'
]

default['jenkinsstack']['packages'] = [
  'git'
]

default['jenkinsstack']['slave']['executors'] = 6
