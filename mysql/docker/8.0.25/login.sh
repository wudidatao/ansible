docker exec -it mysql-test-8.0.25-3306 mysql -uroot -p
#配置root本地密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'DoXT$We^O0($';
ALTER USER 'root'@'%' IDENTIFIED BY 'DoXT$We^O0($';
#默认本地root和%root都是所有权限，无需授权
#GRANT ALL PRIVILEGES ON *.* TO "root"@"%";

#配置用户密码配置权限
CREATE USER 'nacos'@'%' IDENTIFIED BY 'XusbH6Lh^B5V';
GRANT ALL PRIVILEGES ON nacos.* TO 'nacos'@'%';

select host,user,plugin from mysql.user;
