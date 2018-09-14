## Docker_Mariadb容器应用

### 0.说明
0.1. 镜像有时区问题

### 1.安装镜像
```
# docker run --name mairadb \
-h mariadb -p 3306:3306 \
-v /etc/localtime:/etc/localtime:ro \
-v /data/mysql/:/var/lib/mysql/:rw -v /data/mysql.conf.d/:/etc/mysql/conf.d/ -e MYSQL_ROOT_PASSWORD=112233 -d mariadb:10.3.6
```

2.


3.



4.
