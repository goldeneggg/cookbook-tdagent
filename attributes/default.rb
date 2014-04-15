default['tdagent']['td_log_dir'] = "/var/log/td-agent"
default['tdagent']['fluent_log_dir'] = "/var/log/fluent"
default['tdagent']['sysctl_conf'] = "/etc/sysctl.conf"
default['tdagent']['sysctl_path'] = "/sbin/sysctl"
default['tdagent']['plugins'] = ['fluent-plugin-elasticsearch']
default['tdagent']['additional_plugins'] = []

# variable for td-agent conf
default['tdagent']['conf']['time_format'] = "%Y-%m-%d %H:%M:%S %z"
default['tdagent']['conf']['forward_tag_prefix'] = "forward"
default['tdagent']['conf']['source']['http_port'] = "9880"
default['tdagent']['conf']['source']['http_tag_prefix'] = "debug"
default['tdagent']['conf']['source']['tail_apache_format'] = "apache2"
default['tdagent']['conf']['source']['tail_apache_access_logdir'] = "/var/log/httpd"
default['tdagent']['conf']['source']['tail_apache_access_logfile'] = "access_log"
default['tdagent']['conf']['source']['tail_apache_pos_file'] = "#{default['tdagent']['td_log_dir']}/#{default['tdagent']['conf']['source']['tail_apache_access_logfile']}.pos"
default['tdagent']['conf']['source']['tail_apache_tag'] = "apache.access"
default['tdagent']['conf']['source']['tail_custom_regexp_cointran'] = "/^ *(?<month>\\d+)[^ ]+ (?<day>[0-3]\\d) (?<hour>\\d\\d):(?<minute>\\d\\d):(?<second>\\d\\d) [^ ]* \\(pid: (?<pid>\\d+)\\) \\[[^ ]*\\] <(?<sign>(begin|end)):(?<ts>\\d+):[0-9]+-(?<add_remove>(add|remove))-[0-9]+>( user_id=\\[(?<user_id>\\d+)\\] transaction_coin=\\[(?<transaction_coin>\\d+)\\] type=\\[(?<type>\\d+)\\] subtype=\\[(?<subtype>\\d+)\\] expire=\\[(?<expire>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2})\\] ctime=\\[(?<ctime>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2})\\] attr=\\[.*payment_transaction_provider:(?<transaction_provider>\\d+).*\\] log=\\[(?<log>.*)\\] recent_expire=\\[(?<recent_expire>.*)\\] timestamp=\\[(?<timestamp>\\d*)\\]|.*)$/" # coin transaction log
default['tdagent']['conf']['source']['tail_custom_logdir'] = "/var/log"
default['tdagent']['conf']['source']['tail_custom_logfile'] = "custom.log"
default['tdagent']['conf']['source']['tail_custom_pos_file'] = "#{default['tdagent']['td_log_dir']}/#{default['tdagent']['conf']['source']['tail_custom_logfile']}.pos"
default['tdagent']['conf']['source']['forward_port'] = "24224"
default['tdagent']['conf']['source']['forward_bind'] = "0.0.0.0"
default['tdagent']['conf']['source']['exec_command'] = "ls -l /root"
default['tdagent']['conf']['source']['exec_keys'] = "k1,k2,k3"
default['tdagent']['conf']['source']['exec_tag_key'] = "k1"
default['tdagent']['conf']['source']['exec_time_key'] = "k2"
default['tdagent']['conf']['source']['exec_run_interval'] = "10s"

default['tdagent']['conf']['match']['file_time_slice_format'] = "%Y%m%d"
default['tdagent']['conf']['match']['file_time_slice_wait'] = "10m"
default['tdagent']['conf']['match']['file_is_compress'] = false
default['tdagent']['conf']['match']['forward_pattern'] = "forward**"
default['tdagent']['conf']['match']['forward_send_timeout'] = "60s"
default['tdagent']['conf']['match']['forward_recover_wait'] = "10s"
default['tdagent']['conf']['match']['forward_heartbeat_interval'] = "1s"
default['tdagent']['conf']['match']['forward_phi_threshold'] = "8"
default['tdagent']['conf']['match']['forward_hard_timeout'] = "20s"

# !!! require override YOUR_SERVER_NAME, YOUR_IP !!!
default['tdagent']['conf']['match']['forward_servers'] = [
    {'name' => 'YOUR_SERVER_NAME', 'host' => 'YOUR_IP', 'port' => 24224, 'weight' => 100 },
]

default['tdagent']['conf']['match']['forward_secondary_logfile'] = "forward-failed"
default['tdagent']['conf']['match']['exec_pattern'] = "exec.**"
default['tdagent']['conf']['match']['exec_command'] = "ls -l /root"
default['tdagent']['conf']['match']['exec_keys'] = "k1,k2,k3"
default['tdagent']['conf']['match']['exec_tag_key'] = "k1"
default['tdagent']['conf']['match']['exec_time_key'] = "k2"
default['tdagent']['conf']['match']['es_is_sin'] = false
default['tdagent']['conf']['match']['es_pattern'] = "es.apache"
default['tdagent']['conf']['match']['es_type_name'] = "apache"
default['tdagent']['conf']['match']['es_log_stash_format'] = "true"
default['tdagent']['conf']['match']['es_host'] = "192.168.56.41"
default['tdagent']['conf']['match']['es_port'] = "9200"

default['tdagent']['tcp_accept_port_and_ips'] = {
    '24224' => ['192.168.56.0/24']
}
default['tdagent']['iptables_script'] = "/etc/init.d/iptables"
default['tdagent']['iptables_rule_file'] = "/etc/sysconfig/iptables"

# !!! require override in sub-attribute !!!
default['tdagent']['ruby_prefix'] = "/hoge/huga"

default['tdagent']['install_type'] = case node['platform_family']
    when "rhel", "fedora"
        "yum"
    when "debian"
        # TODO
        "apt"
    else
        # TODO
        "source"
end
include_attribute "cookbook-tdagent::#{node['tdagent']['install_type']}"
