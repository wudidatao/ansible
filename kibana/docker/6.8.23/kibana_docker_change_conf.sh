#!/bin/bash

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
kibana_network=$8
es_ip=$9
es_port=${10}

#初始化所有容器相关内容
function InitSet(){
  #创建初始化用户
  if id -u $kibana_user >/dev/null 2>&1;then
    echo $kibana_user"用户已创建"
  else
    sudo /usr/sbin/groupadd $kibana_user -g 1000 -o
    sudo /usr/sbin/useradd $kibana_user -u 1000 -g $kibana_user -s /sbin/nologin -o
  fi

  #初始化目录
  mkdir -p $kibana_home $kibana_data $kibana_conf $kibana_logs

  #权限调整
  sudo chown -R $kibana_user:$kibana_user $kibana_home
}

function configInitSet(){
  #添加端口
  #echo "server.port: $kibana_port" >> $kibana_conf/config/kibana.yml
  #sed -i "s/#server.port: 5601/server.port: $kibana_port/g" $kibana_conf/config/kibana.yml
  #sed -i "s/#network.host: "0.0.0.0"/network.host: $kibana_ip/g" $kibana_conf/config/kibana.yml
  #sed -i "s/#server.publicBaseUrl: \"\"/server.publicBaseUrl:$kibana_ip:$kibana_port/g" $kibana_conf/config/kibana.yml

  #修改es配置
  sed -i "s/elasticsearch.hosts: \[ \"http:\/\/elasticsearch:9200\" \]/elasticsearch.hosts: \[ \"http:\/\/$es_ip:$es_port\" \]/g" $kibana_conf/config/kibana.yml
  #配置登录账号密码
  echo "" >> $kibana_conf/config/kibana.yml
  echo "elasticsearch.username: \"elastic\"" >> $kibana_conf/config/kibana.yml
  echo "elasticsearch.password: \"$kibana_pass\"" >> $kibana_conf/config/kibana.yml

}

case $1 in
  init)
  InitSet;;
  create)
  configInitSet;;
esac
