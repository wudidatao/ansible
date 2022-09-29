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

if [ $1 == "init" ];then
  #1.初始化容器
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -u $grafana_user:root -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image

  sleep 10s

  #2.复制配置
  sudo docker cp $grafana_container_name:/etc/grafana/   $grafana_conf/
  sudo docker cp $grafana_container_name:/var/lib/grafana/   $grafana_data/

  #3.删除容器但不删除数据
  docker rm -vf $grafana_container_name
fi

if [ $1 == "clean" ];then
  docker rm -vf $grafana_container_name
fi

if [ $1 == "create" ];then
  #只能使用root用户，grafana用户会有权限写入问题
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -u $grafana_user:root -v $grafana_conf/grafana:/etc/grafana -v $grafana_data/grafana/:/var/lib/grafana/ -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image
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

if [ $1 == "upgrade" ] ;then
  docker stop ${grafana_description}-1.22.0-${grafana_port}
  docker run -d --privileged -p $grafana_port:$grafana_port --net $network_mode -v $grafana_conf/grafana.conf:/etc/grafana/grafana.conf -v $grafana_data/html:/usr/share/grafana/html  -v $grafana_logs:/var/log/grafana -v /etc/localtime:/etc/localtime --name $grafana_container_name $docker_image
fi