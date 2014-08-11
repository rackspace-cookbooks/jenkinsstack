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
