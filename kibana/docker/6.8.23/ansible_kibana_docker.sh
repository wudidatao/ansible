#!/bin/bash

. ./var.sh

#操作参数控制
if [ -z $1 ];then
  echo "请输入第一个操作参数"
  exit 0
fi

if [ $1 <> "push" ] || [ $1 <> "pull" ] || [ $1 <> "init" ] || [ $1 <> "create" ] || [ $1 <> "clean" ];then
  echo "输入有误，默认执行status，详情请参考:
推送镜像到仓库 push
节点拉取镜像 pull
节点初始化容器但不创建（一般用于调试配置） init
节点初始化容器同时创建容器 create

节点重启 restart
节点升级 upgrade"
fi

if [ $1 == "push" ];then
  ansible $harbor_ip -m script -a "kibana_docker.sh push $harbor_ip $harbor_library $kibana_version"
fi

if [ $1 == "pull" ];then
  ansible $kibana_ip -m script -a "kibana_docker.sh pull $harbor_ip $harbor_library $kibana_version"
fi

if [ $1 == "init" ];then
  ansible $kibana_ip -m script -a "kibana_docker_change_conf.sh init $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode" 
  ansible $kibana_ip -m script -a "kibana_docker.sh init $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode"
fi

if [ $1 == "create" ];then
  ansible $kibana_ip -m script -a "kibana_docker_change_conf.sh init $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode"
  ansible $kibana_ip -m script -a "kibana_docker.sh init $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode"
  ansible $kibana_ip -m script -a "kibana_docker_change_conf.sh create $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode $es_ip $es_port"
  ansible $kibana_ip -m script -a "kibana_docker.sh create $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode"
fi

if [ $1 == "clean" ];then
  ansible $kibana_ip -m script -a "kibana_docker.sh clean $kibana_port $kibana_home $kibana_version $kibana_user $kibana_description $kibana_pass $network_mode"
fi
