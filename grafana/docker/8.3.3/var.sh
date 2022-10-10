#!/bin/bash

#基本变量
grafana_ip=10.248.245.119
grafana_port=3000
grafana_version=8.3.3
grafana_upgrade_version=9.0.0

#路径变量
grafana_home=/data/grafana
grafana_path=${grafana_home}/${grafana_version}-${grafana_port}
grafana_data=${grafana_home}/${grafana_version}-${grafana_port}/data
grafana_conf=${grafana_home}/${grafana_version}-${grafana_port}/conf
grafana_logs=${grafana_home}/${grafana_version}-${grafana_port}/logs

#信息变量
grafana_user=root
grafana_description=grafana-prod
grafana_container_name=${grafana_description}-${grafana_version}-${grafana_port}
network_mode=host

#其他变量
harbor_ip=10.248.245.184

