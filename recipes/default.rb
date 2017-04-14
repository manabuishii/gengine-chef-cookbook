#
# Cookbook Name:: gengine
# Recipe:: default
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

case node[:platform]
when 'debian','ubuntu','centos'
  # defaults are set with cookbook attributes
else
  log("Platform #{node[:platform]} not supported!") { level :fatal }
  exit 1
end

case node[:platform]
when 'centos'
  # add the EPEL repo
  yum_repository 'epel' do
    description 'Extra Packages for Enterprise Linux'
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
    action :create
  end
  directory node[:gengine][:config] do
    owner 'root'
    group 'root'
    mode 0755
  end
end

case node[:gengine][:role]
when 'master'
  include_recipe 'gengine::install_master'
when 'exec'
  include_recipe 'gengine::install_exec'
when 'client'
  include_recipe 'gengine::install_client'
else
  log("The role #{node[:gengine][:role]} is not supported in GridEngine clusters!") { level :fatal }
end
