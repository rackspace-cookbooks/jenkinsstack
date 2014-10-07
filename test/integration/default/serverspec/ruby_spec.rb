# tests for ruby and bundler
describe 'ruby --version should return ruby 1.9.3p484' do
  describe command("su - jenkins -c 'ruby --version'") do
    its(:stdout) { should match(/^ruby 1.9.3p484.*/) }
  end
end

describe 'gem list bundler should return bundler' do
  describe command("su - jenkins -c 'gem list bundler'") do
    its(:stdout) { should match(/^bundler .*/) }
  end
end
