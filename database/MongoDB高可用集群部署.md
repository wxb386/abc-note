# MongoDB副本集+Keepalived部署高可用集群

### 1. 部署前准备
**1.1. 禁用Linux的THP功能**
```
# cat << . >> /etc/rc.d/rc.local && chmod +x /etc/rc.d/rc.local
if [ -f /sys/kernel/mm/transparent_hugepage/enabled ]; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
.
```
**1.2. 创建用户,用户组,数据目录**
```
# groupadd -g 800 mongod \
  && useradd -s /sbin/nologin -u 800 -g mongod mongod \
  && mkdir -p /data/mongo/ \
  && chown -R mongod:mongod /data/mongo/
```

### 2. MongoDB副本集规划

主机名|地址|端口|默认角色
-|-|-|-
mongo-0|192.168.80.11|27017|primary
mongo-1|192.168.80.12|27017|secondary
mongo-2|192.168.80.13|27017|secondary

### 3. 部署MongoDB服务
**3.1. MongoDB怎么使用**
- 启动:`mongod -f /etc/mongo.conf`
- 停止:`mongod -f /etc/mongo.conf --shutdown`
- 使用pkill停止服务:`pkill -2 mongod`

**3.2. 在所有机器上,部署MongoDB**
```
# cd /root/soft/ \
  && curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.6.8.tgz \
  && tar -xf mongodb-linux-x86_64-rhel70-3.6.8.tgz \
  && mv mongodb-linux-x86_64-rhel70-3.6.8 /usr/local/mongdb-3.6.8 \
  && for i in $(ls /usr/local/mongdb-3.6.8/bin/);do ln -sf $i /usr/bin/;done
```
**3.3. 创建MongoDB的配置文件**
```
# cat << . > /etc/mongod.conf
#监听0.0.0.0:27017
bind_ip_all=true
port=27017
#数据库目录
dbpath=/data/mongo/
#副本集名称
replSet=rs0
#开启登录验证,默认先不开启,添加用户后再开启
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
**3.4. 创建MongoDB的启动文件**
```
# echo '#!/bin/bash
MONGOD=/usr/bin/mongod
MONGOCONF=/etc/mongod.conf
InfoFile=/tmp/start.mongo
. /etc/init.d/functions
status(){
  PID=$(awk 'NR==2{print $NF}' $InfoFile)
  Run_Num=$(ps -p $PID|wc -l)
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
  stop && sleep 2 && start;;
status)
  status;;
*)
  echo $"Usage: $0 {start|stop|restart|status}" && exit 1;;
esac' > /etc/init.d/mongod && chmod 755 /etc/init.d/mongod
```
### 4. 配置MongoDB副本集



