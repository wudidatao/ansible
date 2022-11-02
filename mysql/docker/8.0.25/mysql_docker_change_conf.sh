#!/bin/bash

harbor_ip=$2
mysql_version=$3
mysql_port=$4
mysql_home=$5
mysql_path=$6
mysql_data=$7
mysql_conf=$8
mysql_logs=$9
mysql_user=${10}
mysql_description=${11}
mysql_container_name=${12}
network_mode=${13}
harbor_library=mysql
docker_image=$harbor_library:$mysql_version

function initSet(){
  #创建初始化用户
  if id -u $mysql_user >/dev/null 2>&1;then
    echo $mysql_user"用户已创建过"
  else
    sudo /usr/sbin/groupadd $mysql_user -g 999 -o
    sudo /usr/sbin/useradd $mysql_user -u 999 -g $mysql_user -s /sbin/nologin -o
    echo $mysql_user"用户已新创建"
  fi

  #初始化目录
  mkdir -p $mysql_home $mysql_path $mysql_data $mysql_conf $mysql_logs

  #权限调整
  sudo chown -R $mysql_user:$mysql_user $mysql_home

}

function upgrade(){
  #初始化目录，复制原有配置和文件
  mkdir -p $mysql_home $mysql_path
  cp -r $mysql_home/1.22.0-$mysql_port/* $mysql_path

}


case $1 in
  init)
  initSet;;
  upgrade)
  upgrade;;
esac
