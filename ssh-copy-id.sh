#!/bin/bash
#批量节点的单向免密登录

#如果没有创建公钥，则执行，如果创建过，则注释
#ssh-keygen -t rsa -P ''

#发送公钥到以下指定的机器上
for ip in 192.168.100.{191..194}
do
  ssh-copy-id root@$ip
done
