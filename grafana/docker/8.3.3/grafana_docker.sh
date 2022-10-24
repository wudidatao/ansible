#!/bin/bash

harbor_ip=$2
harbor_library=$3
grafana_version=$4
docker_image=$harbor_library:$grafana_version

if [ $1 == "push" ];then
  docker pull $harbor_library/$docker_image
  docker tag $harbor_library/$docker_image $harbor_ip/$harbor_library/$docker_image
  docker push $harbor_ip/$harbor_library/$docker_image
  docker rmi $harbor_library/$docker_image $harbor_ip/$harbor_library/$docker_image
fi

if [ $1 == "pull" ];then
  docker pull $harbor_ip/$harbor_library/$docker_image
  docker tag $harbor_ip/$harbor_library/$docker_image $docker_image
  docker rmi $harbor_ip/$harbor_library/$docker_image
fi

grafana_port=$5
grafana_home=$6
grafana_path=$7
grafana_data=$8
grafana_conf=$9
grafana_logs=${10}
grafana_user=${11}
grafana_description=${12}
grafana_container_name=${13}
network_mode=${14}
grafana_upgrade_version=${15}

if [ $1 == "init" ];then

  #创建初始化用户
  if id -u $grafana_user >/dev/null 2>&1;then
    echo "已存在用户"$grafana_user
  else
    sudo groupadd $grafana_user -g 472 -o
    sudo useradd $grafana_user -u 472 -g $grafana_user -s /sbin/nologin -o
    echo $grafana_user"创建成功"
  fi

  #初始化目录
  mkdir -p $grafana_home $grafana_path $grafana_data $grafana_conf $grafana_logs

  #权限调整
  sudo chown -R $grafana_user:$grafana_user $grafana_home

  #初始化容器
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -u root:root -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image

  sleep 10s

  #复制配置
  sudo docker cp $grafana_container_name:/etc/grafana/   $grafana_conf/
  sudo docker cp $grafana_container_name:/var/lib/grafana/   $grafana_data/

  #删除容器但不删除数据
  docker rm -vf $grafana_container_name
fi

if [ $1 == "create" ];then
  #只能使用root用户，grafana用户会有权限写入问题
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -u root:root -v $grafana_conf/grafana:/etc/grafana -v $grafana_data/grafana/:/var/lib/grafana/ -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image
fi

if [ $1 == "clean" ];then
  docker rm -vf $grafana_container_name
fi

if [ $1 == "delete" ];then
  docker rm -vf $grafana_container_name
  rm $grafana_path -rf
fi

if [ $1 == "status" ];then
   docker ps -a | grep $grafana_container_name
fi

if [ $1 == "start" ];then
  docker start $grafana_container_name
  echo $grafana_container_name启动
fi

if [ $1 == "stop" ];then
  docker stop $grafana_container_name
  echo $grafana_container_name已停止
fi

if [ $1 == "upgrade" ];then
  #停止容器
  docker stop $grafana_container_name
  mkdir $grafana_home/$grafana_upgrade_version-${grafana_port}
  cp -rp $grafana_home/$grafana_version-${grafana_port}/* $grafana_home/$grafana_upgrade_version-${grafana_port}/*
  grafana_container_name=${grafana_description}-${grafana_upgrade_version}-${grafana_port}
  docker_image=$harbor_library:$grafana_upgrade_version
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -u root:root -v $grafana_conf/grafana:/etc/grafana -v $grafana_data/grafana/:/var/lib/grafana/ -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image
fi