# Encoding: utf-8
#
# Cookbook Name:: jenkinsstack
# Recipe:: _prep_master_for_slaves
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'

# inspired_from https://coderwall.com/p/-bohrw

# Install sshkey gem into chef
chef_gem 'sshkey'

# Base location of ssh key
pkey = node['jenkins']['master']['home'] + '/.ssh/id_rsa'

# Generate a keypair with Ruby
require 'sshkey'
sshkey = SSHKey.generate(
  type: 'RSA',
  comment: "#{node['jenkins']['master']['user']}@#{node['jenkins']['master']['host']}"
)

# Create ~/.ssh directory
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 00700
end

# Store private key on disk
template pkey do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  source 'id_rsa.erb'
  variables(
    ssh_private_key: sshkey.private_key
  )
  mode 00600
  action :create_if_missing
end

# Store public key on disk
template "#{pkey}.pub" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  source 'id_rsa.pub.erb'
  variables(
    ssh_public_key: sshkey.ssh_public_key
  )
  mode 00644
  action :create_if_missing
end

# Save public key to chef-server as jenkins_pubkey
ruby_block 'node-save-pubkey' do
  block do
    node.set_unless['jenkinsstack']['jenkins_slave_ssh_pubkey'] = File.read("#{pkey}.pub")
    node.save unless Chef::Config['solo']
  end
end

# Create private key credentials
jenkins_private_key_credentials 'jenkins_slave' do
  description 'Jenkins Slave'
  private_key "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQDay9GHmhaoOuXXtoq5eQhQh09LphJ1VqQPI1mt2Q3eMYAvYOy8\nRIuT0gn8rxix7sfFdyf/kIgPxYcE6zA5k2nv9oEjmVWXJgok/EMaEy8cCNi89ETB\nDlii9p7A/9zm420foswFzB0UdS0+1rLAGuKsNkHgrCkhO8Az5uw6QqTEtQIDAQAB\nAoGAMcwZ0EcdyQQ+s630POpzHgDt50XRBavGgzuEebDhGyUhC6d/ugnPysEPTNd9\nQ2IZTbQlAmGe1hga9t+ghjoq7erhOSGrgT81TBXClT21XCZntJfpYERsVrAT9ppl\nGylVCBb5A2IgmdryzlpJHsFwLYuA0fO94XA9Qadt//Vc7wECQQDz3DCZcfObgIve\n0P4RPkFxAfcMcAOuGluGiUjwW8/iSjE3LgRv6UhG1yGL57uP7Bi2E/J6VHIaLAO4\njbj6tSvxAkEA5bA1Mr+vKlBJW83GmcCg/7XoCCHDYukHlcvlyxBoG7N8dZ8QNBxA\nI/Vua0Yo8+FhZA9+Nw0YVkG0qn8OXrZ5BQJAcxXadcA6eIu89uXo0Zhw5/VGcz81\n7WeRBDgsDQs3W5MqEOGNxIbyzkPfGBjAAtcofl2BlMvfoYxeIS35O5Be8QJABsVn\nDBPyigDL6NTsIeQ32tH2ASddpzDPdG8KWy4ko4xrAtypkZ+zlFvL4YWz91yRjm2W\nfvD34rMVLGGKfuhKMQJBAOJ59tziug41ho/mIDeajUMHYaGmaYlK7UPXrNbc9DEY\n/dpfgLkAOTbIs9tKapOwAvECh4+n0wL1NMchysX2WF4=\n-----END RSA PRIVATE KEY-----\n\n"
end
