# file holding the queue master FQDN for all nodes in the cluster
case  node[:platform]
when 'debian','ubuntu'
  default[:gengine][:files][:qmaster] = '/var/lib/gridengine/default/common/act_qmaster'
when 'centos'
  default[:gengine][:files][:qmaster] = '/usr/share/gridengine/default/common/act_qmaster'
end

