#
# Cookbook Name:: jenkinsstack::acl
# Recipe:: _find_slaves
#
# Copyright (C) 2014 Rackspace
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-sugar'

if Chef::Config[:solo]
  errmsg = 'This recipe uses search if slaves attribute is not set. \
   Chef Solo does not support search.'
  Chef::Log.warn(errmsg)
else
  slaves = search('node', 'tags:jenkinsstack_slave'\
                  " AND chef_environment:#{node.chef_environment}")

  if slaves.nil? || slaves.count == 0
    errmsg = 'Did not find Jenkins slaves to use, but none were set'
    Chef::Log.warn(errmsg)
  else
    node.set['jenkinsstack']['slaves'] = {}
    slaves.each do |slave|
      best_ip = best_ip_for(slave)
      if best_ip.nil? || best_ip.empty?
        Chef::Log.warn("$best_ip_for(#{slave.name}) returned bad value")
      else
        node.set['jenkinsstack']['slaves'][slave.name] = best_ip
      end
    end
  end
end
