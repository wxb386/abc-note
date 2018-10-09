**MongoDB副本集+Keepalived部署高可用集群**
- Mongodb副本集：
NoSQL的产生就是为了解决大数据量、高扩展性、高性能、灵活数据模型、高可用性。但是光通过主从模式的架构远远达不到上面几点，由此MongoDB设计了副本集和分片的功能，先来用用副本集。
- Mongodb副本集的同步机制：
数据复制的目的是使数据得到最大的可用性，避免单点故障引起的整站不能访问的情况的发生，Mongodb的副本集在同一时刻只有一台服务器是可以写的，副本集的主从复制也是一个异步同步的过程，是slave端从primary端获取日志，然后在自己身上完全顺序的执行日志所记录的各种操作（该日志是不记录查询操作的），这个日志就是local数据库中的oplog.rs表，默认在64位机器上这个表是比较大的，占磁盘大小的5%，oplog.rs的大小可以在启动参数中设定：--oplogSize 1000,单位是M。
- Keepalived高可用原理:
Keepalived通过VRRP(虚拟冗余路由协议)检测其他节点优先级,当优先级是同ID节点中最高是,抢占VIP(虚拟IP).节点本身会定时检测指定服务的状态,发生异常时会将优先级(+/-)设定的数值,当检测到本身不是最高优先级时,放弃VIP.

### 关闭THP
Transparent Huge Pages (THP)，通过使用更大的内存页面，可以减少具有大量内存的机器上的缓冲区（TLB）查找的开销。
但是，数据库工作负载通常对THP表现不佳，因为它们往往具有稀疏而不是连续的内存访问模式。您应该在Linux机器上禁用THP，以确保MongoDB的最佳性能。
```
# cat << . >> /etc/rc.d/rc.local
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
.
# chmod +x /etc/rc.d/rc.local
```

### 集群规划
- Docker

主机|地址|对外端口|默认角色
-|-|-|-
mongo-0|192.168.80.254|27000|primary
mongo-1|192.168.80.254|27001|secondary
mongo-2|192.168.80.254|27002|secondary

- 虚拟机

主机|地址|对外端口|默认角色
-|-|-|-
mongo-0|192.168.80.11|27017|primary
mongo-1|192.168.80.12|27017|secondary
mongo-2|192.168.80.13|27017|secondary

### Docker部署
#### 下载MongoDB镜像
```
# docker pull mongo:3.6.8
```

#### 以复制集群方式启动MongoDB - 注意:/data/目录权限要求是999
```
# docker run --name mongo-0 --network host -h mongo-0 \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -v /data/mongo/m0/:/data/db/:rw \
  -d mongo:3.6.8 \
  --dbpath /data/db/ \
  --logpath /data/db/mongo.log \
  --logappend \
  --replSet rs1 \
  --port 27000

# docker run --name mongo-1 --network host -h mongo-1 \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -v /data/mongo/m1/:/data/db/:rw \
  -d mongo:3.6.8 \
  --dbpath /data/db/ \
  --logpath /data/db/mongo.log \
  --logappend \
  --replSet rs1 \
  --port 27001

# docker run --name mongo-2 --network host -h mongo-2 \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -v /data/mongo/m2/:/data/db/:rw \
  -d mongo:3.6.8 \
  --dbpath /data/db/ \
  --logpath /data/db/mongo.log \
  --logappend \
  --replSet rs1 \
  --port 27002
```

## 在任意一台实例配置
```
# mongo 192.168.80.254:27000
> use admin;
switched to db admin
> config = { _id:"rs1", members:[ {_id:0,host:"127.0.0.1:27000"}, {_id:1,host:"127.0.0.1:27001"}, {_id:2,host:"127.0.0.1:27002"} ] };
```

## 初始化副本集
```
> rs.initiate(config);
```

## 查看同步状态
```
> rs.status();
```

## 查看后台日志

## 验证同步数据一致性
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

# 虚拟机部署
- 部署MongoDB

```
# cd /root/soft/
# curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.6.8.tgz
# tar -xf mongodb-linux-x86_64-rhel70-3.6.8.tgz
# mv mongodb-linux-x86_64-rhel70-3.6.8 /usr/local/mongdb-3.6.8
# for i in $(ls /usr/local/mongdb-3.6.8/bin/);do ln -sf $i /usr/bin/;done
```
- 创建用户和用户组

```
# groupadd -g 800 mongod
# useradd -s /sbin/nologin -u 800 -g mongod mongod
```

- 创建数据目录

```
# mkdir -p /data/mongo/
# chown -R mongod:mongod /data/mongo/
```

- 创建配置文件

```
# cat << . > /etc/mongod.conf
#监听0.0.0.0:27017
bind_ip_all=true
port=27017
#数据库目录
dbpath=/data/mongo/
replSet=rs0
auth=false
#keyFile=/data/keyfile
#以守护进程的方式运行MongoDB，创建服务器进程
fork=true
#设置每个数据库将被保存在一个单独的目录
directoryperdb=true
#日志配置
logpath=/data/mongo/mongo.log
logappend=true
.
```

- 启动和关闭服务 - 切记不可`kill -9`

```
# mongod -f /etc/mongo.conf
# mongod -f /etc/mongo.conf --shutdown
# pkill -2 mongod
```

- 启动脚本

```
# cat << . > /etc/init.d/mongod
#!/bin/bash
MONGOD=/usr/bin/mongod
MONGOCONF=/etc/mongod.conf
InfoFile=/tmp/start.mongo
. /etc/init.d/functions
status(){
  PID=`awk 'NR==2{print $NF}' $InfoFile`
  Run_Num=`ps -p $PID|wc -l`
  if [ $Run_Num -eq 2 ]; then
    echo "MongoDB is running"
  else
    echo "MongoDB is shutdown"
    return 3
  fi
}
start() {
  status &>/dev/null
  if [ $? -ne 3 ];then
    action "启动MongoDB,服务运行中..."  /bin/false
    exit 2
  fi
  sudo su - mongod -s /bin/bash -c "$MONGOD -f $MONGOCONF" >$InfoFile 2>/dev/null
  if [ $? -eq 0 ];then
    action "启动MongoDB"  /bin/true
  else
    action "启动MongoDB"  /bin/false
  fi
}
stop() {
  sudo su - mongod -s /bin/bash -c "$MONGOD -f $MONGOCONF --shutdown"  &>/dev/null
  if [ $? -eq 0 ];then
    action "停止MongoDB"  /bin/true
  else
    action "停止MongoDB"  /bin/false
  fi
}
case "$1" in
start)
  start;;
stop)
  stop;;
restart)
  stop;sleep 2;start;;
status)
  status;;
*)
  echo $"Usage: $0 {start|stop|restart|status}";exit 1
esac
.
# chmod 755 /etc/init.d/mongod
```

# Keepalived安装
- 在每台服务器上安装Keepalived
```
# yum install keepalived
```

- 配置Keepalived
```
# cat << . > /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
  router_id LVS_DEVEL
}
vrrp_script check {
  script "echo 'rs.isMaster()' | mongo | grep 'ismaster.*true'"
  interval 5
  weight -50
}
vrrp_instance VI_1 {
  state MASTER
  interface eth0
  virtual_router_id 51
  priority 150
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  virtual_ipaddress {
    192.168.80.15
  }
  track_script {
    check
  }
}
.
```

- 起服务
```
# systemctl restart keepalived
# systemctl enable keepalived
```

- 检查VIP是否切换
```
# ip a s eth0
```

---

---

# MongoDB存储引擎
- mongodb参数:`--storageEngine  <wiredTiger | inMemory>`
1.WiredTiger 存储引擎将数据存储到硬盘文件
1.1.文档级别的并发控制
1.2.检查点
1.3.预先记录日志
1.4.内存使用
1.5.数据压缩
1.6.Disk空间回收

2.In-Memory 存储引擎将数据存储到内存

四，mongod 跟存储引擎相关的参数

1，使用WiredTiger的参数设置

复制代码
```
mongod 
--storageEngine wiredTiger 
--dbpath <path> 
--journal --wiredTigerCacheSizeGB <value>
--wiredTigerJournalCompressor <compressor>
--wiredTigerCollectionBlockCompressor <compressor>
--wiredTigerIndexPrefixCompression <boolean>
```
复制代码
2，使用In-Memory的参数设置

复制代码
```
mongod 
--storageEngine inMemory
--dbpath <path> 
--inMemorySizeGB <newSize>
--replSet <setname>
--oplogSize <value>
```


## MongoDB的配置(可以直接写到配置文件中,若作为启动参数则去掉=添加--)
参数|说明
-|-
logpath=/|日志文件
logaddend=true|追加方式写日志
bind_ip=<ip>|监听地址
dbpath=/|数据存放目录

## Keepalived
db.createUser({user:"root",pwd:"admin",roles:[{role:"root",db:"admin"}]})




