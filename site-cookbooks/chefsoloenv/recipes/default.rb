#
# Cookbook Name:: chefexec-environment
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory "/etc/chef" do
  owner "root"
  group "sysadmin"
  mode 0775
  action :create
end

execute "chmod /etc/chef" do
  command 'chown -R root:sysadmin /etc/chef && chmod -R 775 /etc/chef'
end

