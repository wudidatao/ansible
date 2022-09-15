#!/bin/bash

harbor_ip=$2
grafana_version=$3
grafana_port=$4
grafana_home=$5
grafana_path=$6
grafana_data=$7
grafana_conf=$8
grafana_logs=$9
grafana_user=${10}
grafana_description=${11}
grafana_container_name=${12}
network_mode=${13}
harbor_library=grafana
docker_image=$harbor_library:$grafana_version

function initSet(){
  #创建初始化用户
  if id -u $grafana_user >/dev/null 2>&1;then
    echo $grafana_user"用户已创建过"
  else
    sudo groupadd $grafana_user -g 472 -o
    sudo useradd $grafana_user -u 472 -g $grafana_user -s /sbin/nologin -o
    echo $grafana_user"用户已新创建"
  fi

  #初始化目录
  mkdir -p $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs

  #权限调整
  sudo chown -R $grafana_user:$grafana_user $grafana_home

}

function upgrade(){
  #初始化目录，复制原有配置和文件
  mkdir -p $grafana_home $grafana_path
  #cp -r $grafana_home/1.22.0-$grafana_port/* $grafana_path

}


case $1 in
  init)
  initSet;;
  upgrade)
  upgrade;;
esac

