
- Mongodb副本集：
NoSQL的产生就是为了解决大数据量、高扩展性、高性能、灵活数据模型、高可用性。
但是光通过主从模式的架构远远达不到上面几点，由此MongoDB设计了副本集和分片的功能，先来用用副本集。
- Mongodb副本集的同步机制：
数据复制的目的是使数据得到最大的可用性，避免单点故障引起的整站不能访问的情况的发生，Mongodb的副本集在同一时刻只有一台服务器是可以写的，副本集的主从复制也是一个异步同步的过程，是slave端从primary端获取日志，然后在自己身上完全顺序的执行日志所记录的各种操作（该日志是不记录查询操作的），这个日志就是local数据库中的oplog.rs表，默认在64位机器上这个表是比较大的，占磁盘大小的5%，oplog.rs的大小可以在启动参数中设定：--oplogSize 1000,单位是M。


# 集群规划 - Docker
主机|地址|对外端口|默认角色
-|-|-|-
mongodb-0|172.17.0.200|27000|primary
mongodb-1|172.17.0.201|27001|secondary
mongodb-2|172.17.0.202|27002|secondary

# 下载MongoDB镜像
```
# docker pull mongodb:4.0.1
```

# 以复制集群方式启动MongoDB
```
# docker run --name mongodb-0 -h mongodb-0 \
-v /data/mongo/m0/db/:/data/db/:rw \
-v /data/mongo/m0/configdb/:/data/configdb/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--ip 172.17.0.200 \
--add-host m0:172.17.0.200 \
--add-host m1:172.17.0.201 \
--add-host m2:172.17.0.202 
-p 27000:27017/tcp -d mongodb:4.0.1 \
--replSet repset --oplogSize 2048 --logpath /data/mongod.log

# docker run --name mongodb-1 -h mongodb-1 \
-v /data/mongo/m1/db/:/data/db/:rw \
-v /data/mongo/m1/configdb/:/data/configdb/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--ip 172.17.0.201 \
--add-host m0:172.17.0.200 \
--add-host m1:172.17.0.201 \
--add-host m2:172.17.0.202 
-p 27001:27017/tcp -d mongodb:4.0.1 \
--replSet repset --oplogSize 2048 --logpath /data/mongod.log

# docker run --name mongodb-2 -h mongodb-2 \
-v /data/mongo/m2/db/:/data/db/:rw \
-v /data/mongo/m2/configdb/:/data/configdb/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--ip 172.17.0.202 \
--add-host m0:172.17.0.200 \
--add-host m1:172.17.0.201 \
--add-host m2:172.17.0.202 
-p 27002:27017/tcp -d mongodb:4.0.1 \
--replSet repset --oplogSize 2048 --logpath /data/mongod.log
```

在任意一台实例配置


初始化副本集


查看同步状态



查看后台日志




验证同步数据一致性

验证主从自动切换

启动报错











