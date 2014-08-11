
describe package('nginx') do
  it { should be_installed }
end

describe file('/etc/ssl/private/jenkins.key') do
  it { should be_file }
  its(:content) { should match(/BEGIN RSA PRIVATE KEY/) }
end

describe file('/etc/ssl/certs/jenkins.pem') do
  it { should be_file }
  its(:content) { should match(/BEGIN CERTIFICATE/) }
end

describe file("/etc/nginx/sites-available/jenkins") do
  it { should be_file }
  its(:content) { should match(/proxy_pass http:\/\/127.0.01:8080;/) }
  its(:content) { should match(/ssl_certificate  .*/) }
  its(:content) { should match(/ssl_certificate_key  .*/) }
end

describe file("/etc/nginx/sites-enabled/jenkins") do
  it { should be_symlink }
end

describe process('nginx') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end
