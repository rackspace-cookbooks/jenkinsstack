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
  its('args') { should match(/--httpListenAddress=127.0.0.1/) }
end

# test with curl here
describe 'jenkins master should be configured for one slave node' do
  describe command('sleep 30 && curl localhost:8080/computer/slave01/load-statistics') do
    its(:stdout) { should match(/.*<title>slave01 Load Statistics \[Jenkins\]<\/title>.*/) }
  end
end
