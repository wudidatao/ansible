#!/bin/bash

. ./var.sh

#操作参数控制
if [ -z $1 ];then
  echo "输入有误，详情请参考:
推送镜像到仓库 push
从仓库拉取镜像 pull
初始化容器数据（用于调试配置） init
创建容器 create
清除容器但保留数据 clean
删除容器和所有数据 delete

节点容器运行状态 status
节点启动 start
节点停止 stop
节点重启 restart
节点升级 upgrade"
fi

if [ $1 = "push" ];then
  ansible $harbor_ip -m script -a "grafana_docker.sh $1 $harbor_ip $harbor_library $grafana_version"
fi

if [ $1 = "pull" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh $1 $harbor_ip $harbor_library $grafana_version"
fi

if [ $1 == "init" ] || [ $1 == "create" ] || [ $1 == "clean" ] || [ $1 == "delete" ] || [ $1 == "status" ] || [ $1 == "start" ] || [ $1 == "stop" ] || [ $1 == "restart" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh $1 $harbor_ip $harbor_library $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode"
fi

if [ $1 == "upgrade" ];then
  ansible $grafana_ip -m script -a "grafana_docker.sh $1 $harbor_ip $harbor_library $grafana_version $grafana_port $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs $grafana_user $grafana_description $grafana_container_name $network_mode $grafana_upgrade_version"
fi