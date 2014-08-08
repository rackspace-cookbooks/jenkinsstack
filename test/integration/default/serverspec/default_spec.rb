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

# test with curl here
describe 'jenkins master' do
  it 'should find the slave node in jenkins' do
    expect(command 'curl localhost:8080/computer/slave01/load-statistics')
    .to return_stdout(/.*<title>slave01 Load Statistics \[Jenkins\]<\/title>.*/)
  end
end

# ensure all the plugins installed
describe file('/var/lib/jenkins/plugins/credentials') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/ssh-credentials') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/scm-api') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/multiple-scms') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/git-client') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/git') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/github-api') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/github') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/ghprb') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/jquery') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/backup') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/mailer') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/javadoc') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/maven-plugin') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/violations') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/dashboard-view') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/buildgraph-view') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/parameterized-trigger') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/build-pipeline-plugin') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/jclouds-jenkins') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/plugins/simple-theme-plugin') do
  it { should be_directory }
end
