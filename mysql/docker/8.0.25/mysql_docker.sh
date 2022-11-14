#!/bin/bash

harbor_ip=$2
harbor_library=$3
mysql_version=$4
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

mysql_port=$5
mysql_home=$6
mysql_path=$7
mysql_data=$8
mysql_conf=$9
mysql_logs=${10}
mysql_user=${11}
mysql_description=${12}
mysql_container_name=${13}
network_mode=${14}
mysql_upgrade_version=${15}

if [ $1 == "init" ];then

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
  
  #初始化容器
  docker run -d -p $mysql_port:$mysql_port --net $network_mode -v /etc/localtime:/etc/localtime -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name $mysql_container_name $docker_image

  #复制配置
  sudo docker cp $mysql_container_name:/etc/mysql/conf.d $mysql_conf/

  #删除容器但不删除数据
  docker rm -vf $mysql_container_name
fi

if [ $1 == "clean" ];then
  docker rm -vf $mysql_container_name
fi

if [ $1 == "delete" ];then
  docker rm -vf $mysql_container_name
  rm $mysql_path -rf
fi

if [ $1 == "create" ];then
  docker run -d -p $mysql_port:$mysql_port --net $network_mode -v $mysql_conf/conf.d:/etc/mysql/conf.d -v $mysql_data:/var/lib/mysql -v $mysql_logs:/var/log/mysql -v /etc/localtime:/etc/localtime -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name $mysql_container_name $docker_image
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
  docker stop $mysql_container_name
  mkdir $mysql_home/$mysql_upgrade_version-${mysql_port}
  chown -R $mysql_user:$mysql_user $mysql_home/$mysql_upgrade_version-${mysql_port}
  cp -rp $mysql_home/$mysql_version-${mysql_port}/* $mysql_home/$mysql_upgrade_version-${mysql_port}/
  mysql_container_name=${mysql_description}-${mysql_upgrade_version}-${mysql_port}
  docker_image=$harbor_library:$mysql_upgrade_version
  docker run -d -p $mysql_port:$mysql_port --net $network_mode -v $mysql_conf/conf.d:/etc/mysql/conf.d -v $mysql_data:/var/lib/mysql -v $mysql_logs:/var/log/mysql -v /etc/localtime:/etc/localtime -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name $mysql_container_name $docker_image
fi
