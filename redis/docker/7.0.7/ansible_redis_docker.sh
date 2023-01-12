#!/bin/bash

. ./var.sh

if [ -z $1 ];then
  echo "输入有误，详情请参考:
  push 上传镜像
  pull 下载镜像
  create 创建建单节点
  clean 清理容器
  check 节点状态检查
  cluster-create 创建集群关系
  cluster-node-create-init 初始化创建集群节点
  cluster-node-create 创建集群节点
  delete 清理容器和数据
  init 初始化创建单节点
  master-init  初始化创建复制主节点
  master-create 创建复制主节点
  slave-init 初始化创建复制从节点
  slave-create 创建复制从节点
  restart 重启节点
  stop 停止节点
  start 启动节点
  status 节点容器运行状态
  upgrade 节点版本升级"
else
  if [ $1 == "push" ];then
    ansible $harbor_ip -m script -a "redis_docker.sh $1 $harbor_ip $harbor_library $redis_version"
  fi

  if [ $1 == "pull" ];then
    ansible $redis_ip -m script -a "redis_docker.sh $1 $harbor_ip $harbor_library $redis_version"
  fi

  if [ $1 == "cluster-node-create-init" ] || [ $1 == "cluster-node-create" ] || [ $1 == "create" ] || [ $1 == "clean" ] || [ $1 == "delete" ] || [ $1 == "init" ] || [ $1 == "master-init" ] || [ $1 == "master-create" ] || [ $1 == "restart" ] || [ $1 == "status" ] || [ $1 == "start" ] || [ $1 == "stop" ] || [ $1 == "upgrade" ];then
    ansible $redis_ip -m script -a "redis_docker.sh $1 $harbor_ip $harbor_library $redis_version $redis_port $redis_home $redis_path $redis_data $redis_conf $redis_logs $redis_user $redis_description $redis_container_name $network_mode $redis_upgrade_version $redis_pass"
  fi

  if [ $1 == "slave-init" ] || [ $1 == "slave-create" ];then
    ansible $redis_ip -m script -a "redis_docker.sh $1 $harbor_ip $harbor_library $redis_version $redis_port $redis_home $redis_path $redis_data $redis_conf $redis_logs $redis_user $redis_description $redis_container_name $network_mode $redis_upgrade_version $redis_pass $redis_master_ip $redis_master_port"
  fi

  if [ $1 == "cluster-create" ];then
    sudo bash -vx redis_docker.sh $1 $harbor_ip $harbor_library $redis_version $redis_port $redis_home $redis_path $redis_data $redis_conf $redis_logs $redis_user $redis_description $redis_container_name $network_mode $redis_upgrade_version $redis_pass "$clusterip" $replicas
  fi
fi