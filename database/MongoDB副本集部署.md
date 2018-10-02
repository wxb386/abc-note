MongoDB副本集部署
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
-v /data/mongo/m0/:/data/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--network=host -d mongodb:4.0.1 --replSet repset --port 27000

# docker run --name mongodb-1 -h mongodb-1 \
-v /data/mongo/m1/:/data/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--network=host -d mongodb:4.0.1 --replSet repset --port 27001

# docker run --name mongodb-2 -h mongodb-2 \
-v /data/mongo/m2/:/data/:rw \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
--network=host -d mongodb:4.0.1 --replSet repset --port 27002
```

# 在任意一台实例配置
```
# mongo 192.168.80.254:27000
> use admin;
switched to db admin
> config = { _id:"repset", members:[ {_id:0,host:"127.0.0.1:27000"}, {_id:1,host:"127.0.0.1:27001"}, {_id:2,host:"127.0.0.1:27002"} ] };
```

# 初始化副本集
```
> rs.initiate(config);
```

# 查看同步状态
```
> rs.status();
```

# 查看后台日志

# 验证同步数据一致性
1.去主库m0录入数据
```
# mongo 192.168.80.254:27000
repset:PRIMARY> use my_test;
repset:PRIMARY> db.my_test.insert({"uid":"20180921"},{"uname":"centos"});
repset:PRIMARY> exit
```

2.去备库m1检查数据
```
# mongo 192.168.80.254:27001
repset:SECONDARY> use my_test;
repset:SECONDARY> show tables; //mongodb默认是从主节点读写数据的，副本节点上不允许读，需要设置副本节点可以读。
repset:SECONDARY> db.getMongo().setSlaveOk();
repset:SECONDARY> show tables;
repset:SECONDARY> db.my_test.find();
repset:SECONDARY> exit
```
3.去备库m2检查数据
```
# mongo 192.168.80.254:27002
repset:SECONDARY> use my_test;
repset:SECONDARY> show tables; //mongodb默认是从主节点读写数据的，副本节点上不允许读，需要设置副本节点可以读。
repset:SECONDARY> db.getMongo().setSlaveOk();
repset:SECONDARY> show tables;
repset:SECONDARY> db.my_test.find();
repset:SECONDARY> exit
```


# 验证主从自动切换

# 启动报错


MongoDB存储引擎
- mongodb参数:`--storageEngine  <wiredTiger | inMemory>`
1.WiredTiger 存储引擎将数据存储到硬盘文件
1.1.文档级别的并发控制
1.2.检查点
1.3.预先记录日志
1.4.内存使用
1.5.数据压缩
1.6.Disk空间回收

2.In-Memory 存储引擎将数据存储到内存








