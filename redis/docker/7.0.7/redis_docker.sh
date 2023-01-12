#!/bin/bash

harbor_ip=$2
harbor_library=$3
redis_version=$4
docker_image=$harbor_library:$redis_version

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

redis_port=$5
redis_home=$6
redis_path=$7
redis_data=$8
redis_conf=$9
redis_logs=${10}
redis_user=${11}
redis_description=${12}
redis_container_name=${13}
network_mode=${14}
redis_upgrade_version=${15}
redis_pass=${16}
redis_master_ip=${17}
redis_master_port=${18}

if [ $1 == "clean" ];then
  docker rm -vf $redis_container_name
fi

if [ $1 == "create" ] || [ $1 == "cluster-node-create" ] || [ $1 == "master-create" ] || [ $1 == "slave-create" ];then
  docker run -d -p $redis_port:$redis_port --net $network_mode -u $redis_user:$redis_user -v $redis_conf:/usr/local/etc -v $redis_data:/data -v $redis_logs:/var/log -v /etc/localtime:/etc/localtime  --name $redis_container_name $docker_image redis-server /usr/local/etc/redis.conf
fi

if [ $1 == "cluster-create" ];then
  docker run -d --privileged -p $redis_port:$redis_port --net $network_mode -v $redis_conf:/usr/local/etc  --name $redis_container_name redis:$redis_version
  count=5
  retry=0
  while [ $retry -le $count ]
  do
    redis_cluster_ip=${17}
    replicas=${18}
    docker exec $redis_container_name redis-cli -a $redis_pass --cluster create $redis_cluster_ip --cluster-replicas $replicas --cluster-yes
    if [ $? -eq 0 ]; then
      echo "redis集群创建成功"
      break
    else
      sleep 3s
      echo "等待3秒，第${retry}次重试"
      retry=$((retry + 1))
      continue
    fi
  done
  docker rm -vf $redis_container_name
  rm -rf $redis_container_name
fi

if [ $1 == "delete" ];then
  docker rm -vf $redis_container_name
  rm $redis_path -rf
fi

if [ $1 == "init" ] || [ $1 == "master-init" ] || [ $1 == "slave-init" ] || [ $1 == "cluster-node-create-init" ];then

   #创建初始化用户
  if id -u $redis_user >/dev/null 2>&1;then
    echo $redis_user"用户已创建过"
  else
    sudo /usr/sbin/groupadd $redis_user -g 999 -o
    sudo /usr/sbin/useradd $redis_user -u 999 -g $redis_user -s /sbin/nologin -o
    echo $redis_user"用户已新创建"
  fi

  #初始化目录
  mkdir -p $redis_home $redis_path $redis_data $redis_conf $redis_logs

  #下载配置
  if [ -f $redis_home/$redis_version/redis-$redis_version.tar.gz ];then
    echo 已下载redis-$redis_version.tar.gz
  else
    wget https://download.redis.io/releases/redis-$redis_version.tar.gz -P $redis_home/$redis_version/
    tar xvf $redis_home/$redis_version/redis-$redis_version.tar.gz -C $redis_home/$redis_version/
  fi
  cp $redis_home/$redis_version/redis-$redis_version/redis.conf $redis_conf

  if [ $1 == "init" ] || [ $1 == "master-init" ] || [ $1 == "slave-init" ] || [ $1 == "cluster-node-create-init" ];then
    sed -i "s/^port 6379/port $redis_port/g" $redis_conf/redis.conf
    #开启监听
    sed -i "/^bind 127.0.0.1/a bind 0.0.0.0" $redis_conf/redis.conf
    sed -i "s/^bind 127.0.0.1/#bind 127.0.0.1/g" $redis_conf/redis.conf
    #关闭保护模式
    sed -i "/protected-mode yes/a protected-mode no" $redis_conf/redis.conf
    sed -i "s/^protected-mode yes/# protected-mode yes/g" $redis_conf/redis.conf
    #调整日志位置
    sed -i "s/logfile \"\"/logfile \"\/var\/log\/redis.log\"/g"  $redis_conf/redis.conf
    #开启密码
    sed -i "s/^# requirepass foobared/requirepass $redis_pass/g" $redis_conf/redis.conf
  fi

  if [ $1 == "master-init" ];then
    sed -i "/^# masterauth <master-password>/a masterauth $redis_pass" $redis_conf/redis.conf
  fi

  if [ $1 == "slave-init" ];then
    sed -i "/^# replicaof <masterip> <masterport>/a replicaof $redis_master_ip $redis_master_port" $redis_conf/redis.conf
    #从库权重调整
    sed -i "s/replica-priority 100/replica-priority 90/g" $redis_conf/redis.conf
    #开启密码
    sed -i "s/^# masterauth <master-password>/ masterauth $redis_pass/g" $redis_conf/redis.conf
  fi

  if [ $1 == "cluster-node-create-init" ];then
    sed -i "/^# cluster-enabled yes/a cluster-enabled yes" $redis_conf/redis.conf
    sed -i "/^# cluster-config-file nodes-6379.conf/a cluster-config-file nodes-$redis_port.conf" $redis_conf/redis.conf
  fi

  #权限调整
  sudo chown -R $redis_user:$redis_user $redis_home
  
  #初始化容器
  docker run -d -p $redis_port:$redis_port --net $network_mode -u $redis_user:$redis_user -v $redis_conf:/usr/local/etc -v $redis_data:/data -v $redis_logs:/var/log -v /etc/localtime:/etc/localtime  --name $redis_container_name $docker_image redis-server /usr/local/etc/redis.conf

  #删除容器但不删除数据
  docker rm -vf $redis_container_name
fi

if [ $1 == "status" ];then
   docker ps -a | grep $redis_container_name
fi

if [ $1 == "start" ];then
  docker start $redis_container_name
  echo $redis_container_name启动
fi

if [ $1 == "stop" ];then
  docker stop $redis_container_name
  echo $redis_container_name已停止
fi
