# Encoding: utf-8

require_relative 'spec_helper'

describe file('/var/lib/jenkins') do
  it { should be_directory }
end

describe port(8080) do
  it { should be_listening }
end

describe process('java') do
  it { should be_running }
end
