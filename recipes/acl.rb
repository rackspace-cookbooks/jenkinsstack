#
# Cookbook Name:: jenkinsstack::acl
# Recipe:: default
#
# Copyright (C) 2014 Rackspace
# All rights reserved - Do Not Redistribute
#

add_iptables_rule('INPUT', '-s 0.0.0.0/0 -i eth0 -j ACCEPT', 999, 'allow all into jenkins (uncontroled)')
