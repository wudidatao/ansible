#!/bin/bash

. ./var.sh

if [ $1 = "push" ];then
  ansible $harbor_ip -m script -a "mysql_docker.sh $1 $harbor_ip $harbor_library $mysql_version"
fi

if [ $1 = "pull" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh $1 $harbor_ip $harbor_library $mysql_version"
fi

if [ $1 == "clean" ] || [ $1 == "create" ] || [ $1 == "delete" ] || [ $1 == "init" ] || [ $1 == "status" ] || [ $1 == "start" ] || [ $1 == "stop" ] || [ $1 == "restart" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh $1 $harbor_ip $harbor_library $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "upgrade" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh $1 $harbor_ip $harbor_library $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode $mysql_upgrade_version"
fi

