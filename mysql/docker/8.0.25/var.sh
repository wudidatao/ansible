#!/bin/bash

#基本变量
mysql_ip=10.248.245.119
mysql_port=3306
mysql_version=8.0.25
mysql_upgrade_version=8.0.31

#路径变量
mysql_home=/data/mysql
mysql_path=${mysql_home}/${mysql_version}-${mysql_port}
mysql_data=${mysql_home}/${mysql_version}-${mysql_port}/data
mysql_conf=${mysql_home}/${mysql_version}-${mysql_port}/conf
mysql_logs=${mysql_home}/${mysql_version}-${mysql_port}/logs

#信息变量
mysql_user=mysql
mysql_description=mysql-test
mysql_container_name=${mysql_description}-${mysql_version}-${mysql_port}
network_mode=host

#其他变量
harbor_ip=10.248.245.184
harbor_library=mysql
