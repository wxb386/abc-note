SRS直播转发服务

更新日期:2018-11-06

1)需要先编译好srs
2)需要依赖libva
3)容器内挂载的目录是/project/srs/objs/nginx/html/
4)默认开放端口是1935,1985,8000



1.编译安装

2.下载依赖包
# curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo && yum install --downloadonly --downloaddir=/usr/local/srs/ libva

3.创建构建文件
# cd /data/project/srs/docker/

# cat << EOF > Dockerfile
FROM centos:7.5.1804
MAINTAINER wxb@rich-f.com
WORKDIR /project/
# 字符编码设置为en_US.utf8
ENV LANG en_US.utf8
# 时区设置为Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 定制容器
COPY . /project/
RUN yum -y install /project/rpm/*.rpm && rm -rf /project/rpm/
# 启动脚本,这个脚本并不存在,需要启动容器时挂载进来
ENTRYPOINT /project/start.sh && echo "容器启动了又结束了,啦啦啦~"
EOF


# cat << EOF > start.sh && chmod 755 start.sh
#!/bin/bash
cd /project/srs/
./objs/srs -c ./conf/srs.conf
tail -F ./objs/srs.log
EOF

# docker build -t srs:latest .

4.启动容器
# docker run --name srs --network host -v /data/project/srs/html/:/project/srs/objs/nginx/html/:rw -d srs && docker logs -f srs


4.












5.


