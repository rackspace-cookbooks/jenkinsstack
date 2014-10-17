# jenkinsstack

Stack used to configure a jenkins master and any number of jenkins slaves. By default, the stack uses SSH slaves (master initiated) as opposed to JNLP slaves (slave initiated). The master generates a private key that is used for jenkins authentication as well as passwordless SSH from master to slaves.

## Disclaimers

Changing of Jenkins SSH key pairs should be considered unsupported.  If a specific SSH key is desired, please add this before the initial buildout.  It is possible to manually change this, but it does require manual changes on the server.

## [Changelog](CHANGELOG.md)

See CHANGELOG.md for additional information about changes to this stack over time.

## Supported Platforms

Ubuntu 12.04, Ubuntu 14.04, CentOS 6.5

## Attributes

Here are attributes exposed by this stack. Please note that you may also override many attributes from the [upstream cookbook](https://github.com/opscode-cookbooks/jenkins).

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['nginx_proxy']</tt></td>
    <td>Boolean</td>
    <td>whether to configure a locked-down nginx proxy in front of jenkins (mostly for testing. real customers will want specific security.)</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['site_name']</tt></td>
    <td>String</td>
    <td>the server name to use for the nginx proxy</td>
    <td><tt>jenkins</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['rax_theme']</tt></td>
    <td>Boolean</td>
    <td>whether to include install the Rackspace theme</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['slave']['executors']</tt></td>
    <td>integer</td>
    <td>How many executors to configure on each slave</td>
    <td><tt>6</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['plugins']</tt></td>
    <td>Array of strings</td>
    <td>Additional Jenkins plugins to install</td>
    <td>See [default.rb](attributes/default.rb)</td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['packages']</tt></td>
    <td>Array of strings</td>
    <td>Additional OS packages to install</td>
    <td>See [default.rb](attributes/default.rb)</td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['server_ruby']</tt></td>
    <td>String</td>
    <td>Version of ruby to install and configure for jenkins user</td>
    <td>`1.9.3-p484`</td>
  </tr>
  <tr>
    <td><tt>['jenkinsstack']['ruby_gems']</tt></td>
    <td>Array of strings</td>
    <td>Additional Ruby gems packages to install</td>
    <td>[`'bundler'`, `'test-kitchen'`]</td>
  </tr>
</table>

## Usage

### jenkinsstack::default

Nothing. This recipe is empty.

### jenkinsstack::java

Calls the jenkins cookbook's java recipe.

### jenkinsstack::master

Configures a Jenkins master. Configures any slaves found using Chef search (slaves are found based on tags used in jenkinsstack::slave).

### jenkinsstack::slave

Configures a Jenkins slave.

### jenkinsstack::ruby

Configures ruby with version `node['jenkinsstack']['server_ruby']` and gems from `['jenkinsstack']['ruby_gems']`. This recipe must be included separately, and is intended to help configure a build environment that uses bundler to run things like rake or test-kitchen.

### jenkinsstack::find_all

Used to populate `['jenkinsstack']['all']` for wrapper cookbooks. Aids in writing IP tables rules for SSH (22), HTTP (80), and HTTPS (443).

### jenkinsstack::_nginx

Normally, there wouldn't be a call out for recipes just used within in the cookbook, but this one bears specific notes. It configures an nginx reverse proxy with basic auth over a self-signed SSL certificate. You will almost certainly want to configure something specific to an app cookbook or customer to listen on 80/443 and proxy to :8080 with appropriate SSL certificates and configuring appropriate authentication for jenkins (these are defaults). Note that by default, jenkins ***does not*** secure itself. You should ***immediately*** login to a new jenkins master and turn on a specific authentication method, even if it is simply the builtin. This recipe prevents needing to do that for most testing and development work with test-kitchen.

## Contributing

See [CONTRIBUTING](https://github.com/AutomationSupport/jenkinsstack/blob/master/CONTRIBUTING.md).

## Authors

Author:: Rackspace (devops-chef@rackspace.com)

## License
```
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
```
