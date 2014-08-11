# tests for ruby and bundler
describe 'ruby --version' do
  it 'should return ruby 1.9.3p484' do
    expect(command "su - jenkins -c 'ruby --version'").to return_stdout(/^ruby 1.9.3p484.*/)
  end
end

describe 'gem list bundler' do
  it 'should return bundler' do
    expect(command "su - jenkins -c 'gem list bundler'").to return_stdout(/^bundler .*/)
  end
end
