# Encoding: utf-8

require_relative 'spec_helper'

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

# tests for ruby and bundler
describe 'ruby --version' do
  it 'should return ruby 1.9.3p484' do
    expect(command "su - jenkins -c 'ruby --version'").to return_stdout(/^ruby 1.9.3p484.*/)
  end
end

describe 'gem list bundler' do
  it 'should return bundler' do
    expect(command "su - jenkins -c 'gem list bundler'").to return_stdout(/^bundler .*/)
  end
end
