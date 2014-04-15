default['tdagent']['yum']['repos'] = "/etc/yum.repos.d/td.repo"

default['tdagent']['yum']['conf_tmpl_type_prefix'] = "default-" # override at nodes OR roles file
# ** attributeファイル内での動的参照では、該当項目をroleでoverrideした場合の値は参照/使用することが出来ない!! **
#default['tdagent']['yum']['conf_tmpl'] = "#{default['tdagent']['yum']['conf_tmpl_type_prefix']}td-agent.conf.erb"
default['tdagent']['yum']['conf_tmpl'] = "td-agent.conf.erb"

default['tdagent']['yum']['conf'] = "/etc/td-agent/td-agent.conf"

# override
default['tdagent']['ruby_prefix'] = "/usr/lib64/fluent/ruby"
