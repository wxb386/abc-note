## MongoDB容器应用

**1.获取镜像**
```
# 从远程仓库下载
docker pull redis:4.0.9
# 本地导入
docker load -i base_redis_4.0.9.tar
```

**2.镜像的一些参数**
```
工作目录:/data
挂载目录:["/data"]
启动命令:["redis-server"]
默认端口:[6379]
```

**3.启动容器**
```
docker run --name redis --network host \
-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
-v /data/project/redis/data/:/data/:rw \
-d redis:4.0.9 [<配置文件名>]
```

