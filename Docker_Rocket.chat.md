# Docker_Rocket.chat服务部署

- 更新时间:2018-09-10
#### 1.下载镜像,镜像重命名
```
# docker pull rocket.chat:0.68.5
# docker pull mongodb:4.0.1
# docker tag docker.io/rocket.chat:0.68.5 rocket.chat:0.68.5
# docker tag docker.io/mongodb:4.0.1 mongodb:4.0.1
# docker rmi docker.io/rocket.chat:0.68.5
# docker rmi docker.io/mongodb:4.0.1
```

2.启动mongodb,挂载数据卷
```
# docker run --name mongodb --network host -h mongodb \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -v /data/mongodb/db/:/data/db/:rw \
  -d mongo:3.6.8 --logpath /data/db/mongo.log --logappend --bind_ip_all --dbpath /data/db/
```

3.启动rocket.chat,连接mongodb
```
# docker run --name rocket.chat --network host --add-host db:127.0.0.1 \
  -h rocket.chat \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro \
  -v /data/rocket.chat/uploads/:/app/uploads/:rw \
  -e ROOT_URL='http://<>:3000' -d rocket.chat:0.68.5 && docker logs -f rocket.chat
```

4.配置防火墙
```
# iptables -I INPUT <> -p tcp -m tcp --dport 3000 -m state --state NEW -j ACCEPT
```

5.浏览器访问rocket.chat,完成初次配置
```

```

6.
```

```



