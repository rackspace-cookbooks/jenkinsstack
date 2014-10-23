# Ensure it's an empty array if no one else has set it
default_unless['elkstack']['config']['custom_logstash']['name'] = []

# Jenkins logging patterns
default['elkstack']['config']['custom_logstash']['name'].push('jenkins')
default['elkstack']['config']['custom_logstash']['jenkins']['name'] = 'input_jenkins'
default['elkstack']['config']['custom_logstash']['jenkins']['cookbook'] = 'jenkinsstack'
default['elkstack']['config']['custom_logstash']['jenkins']['source'] = 'input_jenkins.conf.erb'
default['elkstack']['config']['custom_logstash']['jenkins']['variables'] = { path: node['jenkins']['master']['home'] }
