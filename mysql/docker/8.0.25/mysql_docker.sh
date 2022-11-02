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

if [ $1 == "init" ];then
  docker run -d -p $mysql_port:$mysql_port --net $network_mode -v /etc/localtime:/etc/localtime --name $mysql_container_name $docker_image

  #复制配置
  sudo docker cp $mysql_container_name:/etc/mysql/conf.d $mysql_conf/

  #删除容器但不删除数据
  docker rm -vf $mysql_container_name
fi

if [ $1 == "clean" ];then
  docker rm -vf $mysql_container_name
  rm $mysql_path -rf
fi

if [ $1 == "create" ];then
  docker run -d -p $mysql_port:$mysql_port --net $network_mode -v $mysql_conf/conf.d:/etc/mysql/conf.d -v $mysql_data:/var/lib/mysql  -v $mysql_logs:/var/log/mysql -v /etc/localtime:/etc/localtime -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name $mysql_container_name $docker_image
fi

if [ $1 == "status" ];then
   docker ps -a | grep $mysql_container_name
fi

if [ $1 == "start" ];then
  docker start $mysql_container_name
  echo $mysql_container_name启动
fi

if [ $1 == "stop" ];then
  docker stop $mysql_container_name
  echo $mysql_container_name已停止
fi

if [ $1 == "upgrade" ] ;then
  docker stop ${mysql_description}-1.22.0-${mysql_port}
  docker run -d --privileged -p $mysql_port:$mysql_port --net $network_mode -v $mysql_conf/mysql.conf:/etc/mysql/mysql.conf -v $mysql_data/html:/usr/share/mysql/html  -v $mysql_logs:/var/log/mysql -v /etc/localtime:/etc/localtime --name $mysql_container_name $docker_image
fi
