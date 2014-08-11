# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: nginx
#
# Copyright 2014, Rackspace
#

# Please note that this is a default that is triggered by an attribute
# node['jenkinsstack']['nginx_proxy']. It is intended only a base for newly
# bootstrapped or configured instances. You should write your in a wrapper/app
# cookbook based on this example and configure it with valid SSL certificates.

include_recipe 'nginx-proxy::setup'

# Had to allow these both in the key dir, since openssl's LWRP does that
site_name = 'jenkins'
key_file = "#{node['nginx_proxy']['ssl_key_dir']}/#{site_name}.key"
cert_file = "#{node['nginx_proxy']['ssl_certificate_dir']}/#{site_name}.pem"

openssl_x509 cert_file do
  common_name node.name
  org 'Example Co'
  org_unit 'Example Dept'
  country 'US'
  key_file key_file
end

nginx_proxy site_name do
  ssl_key site_name
  url 'http://127.0.01:8080'
end
