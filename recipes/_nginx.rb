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

password_for_proxy = node['jenkinsstack']['proxy_password']
if password_for_proxy.nil? || password_for_proxy.empty?
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  password_for_proxy = secure_password
  node.set['jenkinsstack']['proxy_password'] = password_for_proxy
end

htpasswd "#{node['nginx']['dir']}/htpassword" do
  user 'jenkins'
  password password_for_proxy
end

# Had to allow these both in the key dir, since openssl's LWRP does that
site_name = 'jenkins'
key_file = "#{node['nginx']['dir']}/#{site_name}.key"
cert_file = "#{node['nginx']['dir']}/#{site_name}.pem"

openssl_x509 cert_file do
  common_name node.name
  org 'Example Co'
  org_unit 'Example Dept'
  country 'US'
  key_file key_file
end

listen_address = node['jenkins']['master']['listen_address']
nginx_proxy site_name do
  ssl_key site_name
  ssl_key_path key_file
  ssl_certificate_path cert_file
  url "http://#{listen_address}:8080"
  custom_config [
    'auth_basic "Restricted";',
    "auth_basic_user_file #{node['nginx']['dir']}/htpassword;"
  ]
end
