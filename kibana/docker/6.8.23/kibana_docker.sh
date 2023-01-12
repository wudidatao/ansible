#!/bin/bash

harbor_ip=$2
harbor_library=$3
kibana_version=$4
docker_image=$harbor_library:$kibana_version

if [ $1 == "push" ];then
  docker pull $docker_image
  docker tag $docker_image $harbor_ip/$harbor_library/$docker_image
  docker push $harbor_ip/$harbor_library/$docker_image
  docker rmi $docker_image $harbor_ip/$harbor_library/$docker_image
fi

if [ $1 == "pull" ];then
  docker pull $harbor_ip/$harbor_library/$docker_image
  docker tag $harbor_ip/$harbor_library/$docker_image $docker_image
  docker rmi $harbor_ip/$harbor_library/$docker_image
fi

kibana_port=$2
kibana_home=$3
kibana_version=$4
kibana_user=$5
kibana_description=$6
kibana_pass=$7
kibana_path=${kibana_home}/${kibana_version}-${kibana_port}
kibana_data=${kibana_home}/${kibana_version}-${kibana_port}/data
kibana_conf=${kibana_home}/${kibana_version}-${kibana_port}/conf
kibana_logs=${kibana_home}/${kibana_version}-${kibana_port}/logs
kibana_container_name=${kibana_description}-${kibana_version}-${kibana_port}
network_mode=$8

if [ $1== "init" ];then
  #创建初始化容器
  docker run -d --privileged -p $kibana_port:$kibana_port --net $network_mode -v /etc/localtime:/etc/localtime --name $kibana_container_name $docker_image
  #复制配置
  sudo docker cp $kibana_container_name:/usr/share/kibana/config/ $kibana_conf
  #配置权限
  sudo chown -R $kibana_user:$kibana_user $kibana_home 
  #删除容器不删除数据
  docker rm -vf $kibana_container_name
fi

if [ $1 == "create" ];then
  #-v $kibana_data:/usr/share/kibana/data
  docker run -d --privileged -p $kibana_port:$kibana_port -v $kibana_conf/config:/usr/share/kibana/config -v /etc/localtime:/etc/localtime --net $network_mode --name $kibana_container_name $docker_image
fi

if [ $1 == "restart" ];then
  docker restart $kibana_container_name
  echo $kibana_container_name已重启
fi

if [ $1 == "start" ];then
  docker start $kibana_container_name
  echo $kibana_container_name启动
fi

if [ $1 == "stop" ];then
  docker stop $kibana_container_name
  echo $kibana_container_name已停止
fi

if [ $1 == "status" ];then
  docker ps -a | grep  $kibana_container_name
fi

if [ $1== "clean" ];then
  docker rm -vf $kibana_container_name
  rm -rf $kibana_path
  echo $kibana_container_name已清除服务和数据
fi