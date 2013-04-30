include_recipe 'glusterfs::base'

package 'glusterfs-client' do
  action :install
end

node[:glusterfs][:client][:mounts].each do |volume, path|
  directory path do
    action :create
    recursive true
  end

  mount path do
    action [:mount, :enable]
    device volume
    fstype 'glusterfs'
  end
end
