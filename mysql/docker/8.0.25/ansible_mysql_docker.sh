#!/bin/bash

. ./var.sh

if [ $1 = "push" ];then
  ansible $harbor_ip -m script -a "mysql_docker.sh push $harbor_ip $mysql_version"
fi

if [ $1 = "pull" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh pull $harbor_ip $mysql_version"
fi

if [ $1 == "init" ];then
  ansible $mysql_ip -m script -a "mysql_docker_change_conf.sh init $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
  ansible $mysql_ip -m script -a "mysql_docker.sh init $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "create" ];then
  ansible $mysql_ip -m script -a "mysql_docker_change_conf.sh create $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
  ansible $mysql_ip -m script -a "mysql_docker.sh create $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode" 
fi

if [ $1 == "clean" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh clean $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "status" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh status $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "start" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh start $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "stop" ];then
  ansible $mysql_ip -m script -a "mysql_docker.sh stop $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi

if [ $1 == "upgrade" ];then
  ansible $mysql_ip -m script -a "mysql_docker_change_conf.sh upgrade $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
  ansible $mysql_ip -m script -a "mysql_docker.sh upgrade $harbor_ip $mysql_version $mysql_port $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs $mysql_user $mysql_description $mysql_container_name $network_mode"
fi
