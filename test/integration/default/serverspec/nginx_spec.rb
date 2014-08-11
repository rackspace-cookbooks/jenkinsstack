
describe package('nginx') do
  it { should be_installed }
end

describe file('/etc/nginx/jenkins.key') do
  it { should be_file }
  its(:content) { should match(/BEGIN RSA PRIVATE KEY/) }
end

describe file('/etc/nginx/jenkins.pem') do
  it { should be_file }
  its(:content) { should match(/BEGIN CERTIFICATE/) }
end

describe file('/etc/nginx/htpassword') do
  # verify test-kitchen's dummy password made it this far
  it { should be_file }
  its(:content) { should match(/jenkins:.*/) }

  # unfortunately, the hash algorithm varies, so we can't check further
end

describe file('/etc/nginx/sites-available/jenkins') do
  it { should be_file }
  its(:content) { should match(%r{proxy_pass http://127.0.0.1:8080;}) }
  its(:content) { should match(/ssl_certificate/) }
  its(:content) { should match(/ssl_certificate_key/) }
  its(:content) { should match(/auth_basic "Restricted";/) }
  its(:content) { should match(%r{auth_basic_user_file /etc/nginx/htpassword;}) }
end

describe file('/etc/nginx/sites-enabled/jenkins') do
  it { should be_linked_to('/etc/nginx/sites-available/jenkins') }
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
