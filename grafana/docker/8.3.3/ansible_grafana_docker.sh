#!/bin/bash

. ./var.sh

if [ $1 = "push" ];then
  ansible $harbor_ip -m script -a "grafana_docker.sh push $harbor_ip $grafana_version"
fi

if [ $1 = "pull" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh pull $harbor_ip $grafana_version"
fi

if [ $1 == "init" ];then
  ansible $grafana_ip -m script -a "grafana_docker_change_conf.sh init $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
  ansible $grafana_ip -m script -a "grafana_docker.sh init $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "create" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh create $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "clean" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh clean $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "status" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh status $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "start" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh start $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "stop" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh stop $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "upgrade" ];then
  ansible $grafana_ip -m script -a "grafana_docker_change_conf.sh upgrade $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
  ansible $grafana_ip -m script -a "grafana_docker.sh upgrade $harbor_ip $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi
