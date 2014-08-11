# Encoding: utf-8

require_relative 'spec_helper'

# test the ruby stuff that is the same on default (jenkins master)
require 'default/serverspec/ruby_spec'

describe user('jenkins') do
  it { should exist }
  it { should belong_to_group 'jenkins' }
  it { should have_home_directory '/var/lib/jenkins' }
  it { should have_authorized_key 'xyz123' }
end

describe package('git') do
  it { should be_installed }
end

describe file('/var/lib/jenkins') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/.ssh') do
  it { should be_directory }
end

describe port(22) do
  it { should be_listening }
end
