include_recipe 'apt'

package 'python-software-properties' do
  action :install
end

execute 'add-apt-repository ppa:semiosis/ubuntu-glusterfs-3.3 --yes' do
  action :run
  notifies :run, resources(:execute => 'apt-get update'), :immediately
end
