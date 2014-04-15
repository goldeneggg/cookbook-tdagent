#
# Cookbook Name:: tdagent
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "optimize_ipv4_parameter" do
    user "root"
    code <<-EOH
        echo "net.ipv4.tcp_tw_recycle = 1" >> #{node['tdagent']['sysctl_conf']}
        echo "net.ipv4.tcp_tw_reuse = 1" >> #{node['tdagent']['sysctl_conf']}
        #{node['tdagent']['sysctl_path']} -w
    EOH
    not_if "grep net.ipv4.tcp_tw_recycle #{node['tdagent']['sysctl_conf']}"
end

# install
include_recipe "cookbook-tdagent::#{node['tdagent']['install_type']}"

# modified iptables
service "iptables" do
    supports :restart => true, :status => true
    action :nothing
end

node['tdagent']['tcp_accept_port_and_ips'].each do |port, ip_list|
    ip_list.each do |ip|
        ['tcp', 'udp'].each do |protocol|
            execute "add_accept_rule_#{ip}_#{port}_#{protocol}" do
                user "root"
                command "iptables -t filter -I INPUT -p #{protocol} -s #{ip} --dport #{port} -j ACCEPT"
                not_if "grep #{ip} #{node['tdagent']['iptables_rule_file']} | grep #{port}"
            end
        end
    end
end

execute "save_iptables" do
    user "root"
    command "#{node['tdagent']['iptables_script']} save"
    notifies :restart, "service[iptables]", :immediately
end

# plugin install
node['tdagent']['plugins'].each do |plugin|
    execute "plugin_#{plugin}" do
        user "root"
        command "#{node['tdagent']['ruby_prefix']}/bin/fluent-gem install #{plugin} --no-ri --no-rdoc -V"
        not_if "#{node['tdagent']['ruby_prefix']}/bin/fluent-gem list -l | grep #{plugin}"
    end
end

# additional plugin install
node['tdagent']['additional_plugins'].each do |plugin|
    execute "plugin_#{plugin}" do
        user "root"
        command "#{node['tdagent']['ruby_prefix']}/bin/fluent-gem install #{plugin} --no-ri --no-rdoc -V"
        not_if "#{node['tdagent']['ruby_prefix']}/bin/fluent-gem list -l | grep #{plugin}"
    end
end
