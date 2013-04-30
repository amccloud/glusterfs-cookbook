include_recipe 'glusterfs::base'
include_recipe 'glusterfs::peer'

node[:glusterfs][:server][:peers].each do |peer|
  execute "gluster peer probe #{peer}" do
    not_if "gluster peer status | grep 'Hostname: #{peer}'" 
  end
end

node[:glusterfs][:server][:volumes].each do |volume, brick|
  stripe = "stripe #{node[:glusterfs][:server][:stripe]}" if node[:glusterfs][:server][:stripe]
  replica = "replica #{node[:glusterfs][:server][:replica]}" if node[:glusterfs][:server][:replica]
  transport = "transport #{node[:glusterfs][:server][:transport]}" if node[:glusterfs][:server][:transport]
  peers = node[:glusterfs][:server][:peers].map{|peer| "#{peer}:#{brick}"}.join(' ')

  execute "gluster volume create #{volume} #{stripe} #{replica} #{transport} #{peers}" do
    not_if "gluster volume info | grep -c 'Volume Name: #{volume}'"
  end

  execute "gluster volume start #{volume}" do
    not_if "gluster volume info #{volume} | grep 'Status: Started'"
  end
end
