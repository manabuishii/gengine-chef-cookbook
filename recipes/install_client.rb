#
# Cookbook Name:: gengine
# Recipe:: install_client
#
# Copyright 2012, Victor Penso
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

case  node[:platform]
when 'debian','ubuntu'
  package 'gridengine-client'
when 'centos'
  package 'gridengine'
  directory "/usr/share/gridengine/default/common" do
    owner node[:gengine][:user]
    group node[:gengine][:group]
    recursive true
    mode 0755
    action :create
  end
  file "/usr/share/gridengine/default/common/bootstrap" do
    owner "sgeadmin"
    group "sgeadmin"
    mode "0644"
    action :create
    content <<-EOC
admin_user             sgeadmin
default_domain          none
ignore_fqdn             true
spooling_method         berkeleydb
spooling_lib            libspoolb
spooling_params         /var/spool/gridengine/default/spooldb
binary_path             /usr/share/gridengine/bin
qmaster_spool_dir       /var/spool/gridengine/default/qmaster
security_mode           none
    EOC
  end
end

# make sure to communicate with the correct master
file node[:gengine][:files][:qmaster] do
  owner node[:gengine][:user]
  group node[:gengine][:group]
  mode 0644
  content "#{node[:gengine][:master]}\n"
end

