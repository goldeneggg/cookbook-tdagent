#
# Cookbook Name:: tdagent
# Recipe:: yum
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "#{node['tdagent']['yum']['repos']}" do
    source "td.repo.erb"
    action :create
end

execute "tdagent_chkconfig_on" do
    command "chkconfig td-agent on"
    action :nothing
end

package "td-agent" do
    action :install
    notifies :run, "execute[tdagent_chkconfig_on]"
end

service "td-agent" do
    action :nothing
end

directory "#{node['tdagent']['fluent_log_dir']}" do
    owner "td-agent"
    action :create
    not_if "ls #{node['tdagent']['fluent_log_dir']}"
end

template "#{node['tdagent']['yum']['conf']}" do
    source "#{node['tdagent']['yum']['conf_tmpl_type_prefix']}#{node['tdagent']['yum']['conf_tmpl']}"
    action :create
    variables :is_service_in_es => node['tdagent']['conf']['match']['es_is_sin']
    notifies :restart, "service[td-agent]", :delayed
    not_if "grep #{node['tdagent']['conf']['sign']} #{node['tdagent']['yum']['conf']}"
end
