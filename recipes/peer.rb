include_recipe 'glusterfs::base'

package 'glusterfs-server' do
  action :install
end

service 'glusterfs-server' do
  supports :status => true, :restart => true, :reload => true
  action :start
end

directory node[:glusterfs][:server][:export_directory] do
  action :create
  recursive true
end
