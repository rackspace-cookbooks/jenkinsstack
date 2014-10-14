# Encoding: utf-8
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

::LOG_LEVEL = :fatal
::UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '12.04',
  log_level: ::LOG_LEVEL
}
::CENTOS_OPTS = {
  platform: 'centos',
  version: '6.5',
  log_level: ::LOG_LEVEL
}
::CHEFSPEC_OPTS = {
  log_level: ::LOG_LEVEL
}

def stub_resources
  stub_command("rpm -qa | grep -q '^runit'").and_return(0)
  stub_command('which nginx').and_return(0)
end

at_exit { ChefSpec::Coverage.report! }
