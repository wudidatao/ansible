#!/bin/bash

#基本变量
redis_ip=10.248.245.119
redis_port=6379
redis_version=7.0.7
redis_upgrade_version=7.0.7
redis_master_ip=10.248.245.119
redis_master_port=6379

#路径变量
redis_home=/data/redis
redis_path=${redis_home}/${redis_version}-${redis_port}
redis_data=${redis_home}/${redis_version}-${redis_port}/data
redis_conf=${redis_home}/${redis_version}-${redis_port}/conf
redis_logs=${redis_home}/${redis_version}-${redis_port}/logs

#信息变量
redis_user=redis
redis_pass=hujbxs0i6ez3yhquy\VMNupd
redis_description=test-redis
redis_container_name=${redis_description}-${redis_version}-${redis_port}
network_mode=host

#其他变量
harbor_ip=10.248.245.184
harbor_library=redis
docker_image=$harbor_library:$redis_version

#集群变量
redis_cluster_ip="10.248.246.34:6379 10.248.246.36:6379 10.248.246.37:6379"
replicas=0