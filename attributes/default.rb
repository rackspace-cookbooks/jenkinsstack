# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: default
#
# Copyright 2014, Rackspace
#

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
