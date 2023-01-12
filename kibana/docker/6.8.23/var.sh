#!/bin/bash

#基本变量
kibana_ip=10.248.245.119
kibana_port=5601
kibana_version=6.8.23
kibana_upgrade_version=

#路径变量
kibana_home=/data/kibana
kibana_path=${kibana_home}/${kibana_version}-${kibana_port}
kibana_data=${kibana_home}/${kibana_version}-${kibana_port}/data
kibana_conf=${kibana_home}/${kibana_version}-${kibana_port}/conf
kibana_logs=${kibana_home}/${kibana_version}-${kibana_port}/logs

#信息变量
kibana_user=kibana
kibana_pass=
kibana_description=test-kibana
network_mode=host

#其他变量
harbor_ip=10.248.245.184
harbor_library=kibana
es_ip=10.248.245.119
es_port=9200