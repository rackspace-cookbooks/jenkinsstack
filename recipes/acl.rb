#
# Cookbook Name:: jenkinsstack::acl
# Recipe:: default
#
# Copyright (C) 2014 Rackspace
# All rights reserved - Do Not Redistribute
#

add_iptables_rule('INPUT', '-m tcp -p tcp --dport 22 -j ACCEPT', 9999, 'Open TCP port for SSH')
add_iptables_rule('INPUT', '-m tcp -p tcp --dport 80 -j ACCEPT', 9999, 'Open TCP port for HTTP')
add_iptables_rule('INPUT', '-m tcp -p tcp --dport 443 -j ACCEPT', 9999, 'Open TCP port for HTTPS')
