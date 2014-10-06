# Encoding: utf-8
name             'jenkinsstack'
maintainer       'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures jenkinsstack'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.1'

depends 'chef-sugar'
depends 'jenkins', '2.1.2' # see github:racker/jenkins before changing this
depends 'build-essential'
depends 'apt'
depends 'user'
depends 'curl'
depends 'rbenv'
depends 'nginx-proxy'
depends 'openssl'
depends 'htpasswd'
depends 'line'
