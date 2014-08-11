# Encoding: utf-8

require_relative 'spec_helper'

describe user('jenkins') do
  it { should exist }
  it { should belong_to_group 'jenkins' }
  it { should have_home_directory '/var/lib/jenkins' }
end

describe package('git') do
  it { should be_installed }
end

describe file('/var/lib/jenkins') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/jenkins.war') do
  it { should be_file }
end

describe file('/var/lib/jenkins/.ssh') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/.ssh/id_rsa') do
  it { should be_file }
  its(:content) { should match(/BEGIN RSA PRIVATE KEY/) }
end

describe file('/var/lib/jenkins/.ssh/id_rsa.pub') do
  it { should be_file }
  its(:content) { should match(/ssh-rsa /) }
end

# theme is currently broken, don't test it, we have it turned off
describe file('/var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml') do
  it { should be_file }
  it { should contain 'canon-jenkins' }
end

describe port(8080) do
  it { should be_listening }
end

describe process('java') do
  it { should be_running }
  its('args') { should match(/-XX:MaxPermSize=512m/) }
  its('args') { should match(/-jar jenkins.war/) }
  its('args') { should match(/--httpPort=8080/) }
  its('args') { should match(/--httpListenAddress=0.0.0.0/) }
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

# test with curl here
describe 'jenkins master' do
  it 'should find the slave node in jenkins' do
    expect(command 'sleep 30 && curl localhost:8080/computer/slave01/load-statistics')
    .to return_stdout(/.*<title>slave01 Load Statistics \[Jenkins\]<\/title>.*/)
  end
end
