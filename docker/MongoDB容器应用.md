## MongoDB容器应用

**1.获取镜像**
```
# 从远程仓库下载
docker pull mongo:3.6.8
# 本地导入
docker load -i base_mongo_3.6.8.tar
```

**2.镜像的一些参数**
```
工作目录:/
挂载目录:["/data/configdb", "/data/db"]
启动命令:["/bin/sh", "-c", "#(nop) ", "CMD [\"mongod\"]"]
默认端口:[27017]
```

**3.启动容器**
```
docker run --name mongo --network host \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
-v /data/project/mongo/data/configdb/:/data/configdb/:rw \
-v /data/project/mongo/data/db/:/data/db/:rw \
-d mongo:3.6.8 [-f <配置文件名> [其他参数]]
```

**4.副本集配置**
```
cd /data/project/mongo/data/db/
cat << EOF > mongod.conf
#监听0.0.0.0:27017
bind_ip_all=true
port=27017
#数据库目录
dbpath=/data/db/
#副本集名称;如仅单机运行,将此选项注释
replSet=rs0
#开启登录验证,默认先不开启,添加用户后再开启
auth=false
#keyFile=/data/db/keyfile
#以守护进程的方式运行MongoDB，创建服务器进程;容器运行应设为false
fork=false
#设置每个数据库将被保存在一个单独的目录
directoryperdb=true
#pid文件
pidfilepath=/data/db/mongo_27017.pid
#日志配置
logpath=/data/db/mongo_27017.log
logappend=true
#启用日志选项，MongoDB的数据操作将会写入到journal文件夹的文件里
journal=true
# 在收到客户数据,检查的有效性
objcheck=true
#操作日志大小限制2G
oplogSize=2048
#0：关闭，不收集任何数据。1：收集慢查询数据，默认是100毫秒。2：收集所有数据
profile=1
slowms=100
EOF
```

**5.设置登录帐号**
```

```
