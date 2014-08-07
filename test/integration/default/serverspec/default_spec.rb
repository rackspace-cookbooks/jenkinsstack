# Encoding: utf-8

require_relative 'spec_helper'

describe package('git') do
  it { should be_installed }
end

describe file('/var/lib/jenkins') do
  it { should be_directory }
end

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
