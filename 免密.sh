#!/bin/bash
#批量节点的单向免密登录
#ssh-keygen -t rsa -P ''
for ip in 192.168.100.{191..194}
do
  ssh-copy-id root@$ip
done
