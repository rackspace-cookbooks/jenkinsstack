#
# Cookbook Name:: jenkinsstack::acl
# Recipe:: _find_master
#
# Copyright (C) 2014 Rackspace
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-sugar'

if Chef::Config[:solo]
  errmsg = 'This recipe uses search if master attribute is not set. \
   Chef Solo does not support search.'
  Chef::Log.warn(errmsg)
else
  results = search('node', 'tags:jenkinsstack_master'\
                  " AND chef_environment:#{node.chef_environment}")

  if results.nil? || results.count == 0
    errmsg = 'Did not find Jenkins master to use, but none were set'
    Chef::Log.warn(errmsg)
  else
    found_master = results.first
    node.run_state['jenkinsstack_master'] = found_master
  end
end
