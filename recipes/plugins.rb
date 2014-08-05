
# Install Jenkins plugins
#
node['rax']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin
end
