#
# Cookbook Name:: gengine
# Recipe:: install_exec
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

# all execution nodes are clients also!
include_recipe 'gengine::install_client'

case  node.platform
when 'debian','ubuntu'
  package 'gridengine-exec'
  service 'gridengine-exec' do
    pattern "sge_execd"
    stop_command "killall sge_execd"
    action [ :enable, :start ]
  end
when 'centos'
  package 'gridengine-execd'
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
  execute "inst_sge" do
    command <<-EOC
      chown sgeadmin:sgeadmin /usr/share/gridengine/default/common/*
      cd /usr/share/gridengine
      touch /usr/share/gridengine/default/common/settings.sh
      sed -i 's/^EXEC_HOST_LIST=.*$/EXEC_HOST_LIST=\"1xrm01.devops.test\"/' ./my_configuration.conf
      ./inst_sge -x -auto ./my_configuration.conf
    EOC
  end
  service 'sge_execd' do
    pattern "sge_execd"
    stop_command "killall sge_execd"
    action [ :enable, :start ]
  end
end


