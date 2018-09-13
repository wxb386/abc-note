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
# docker run --name mongodb --rm -h mongodb -v /etc/localtime:/etc/localtime:ro -v <>:/data/configdb/:rw -v <>:/data/db/:rw -p 27017:27017/tcp -d mongodb:4.0.1
```

3.启动rocket.chat,连接mongodb
```
# docker run --name rocket.chat --link mongodb:db --rm -h rocket.chat -v /etc/localtime:/etc/localtime:ro -v <>:/app/uploads/:rw -p 3000:3000/tcp -e ROOT_URL='http://<>:3000' -d rocket.chat:0.68.5
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



