# Encoding: utf-8
require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/sbin:/sbin:/usr/bin:/bin'
  end
end
