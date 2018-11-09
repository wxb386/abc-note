#!/bin/bash
#

# 读入配置变量,如果有指定版本号,则会按版本号拉取代码
source /data/project/var.sh
[ ! -z "${VERSION}" ] && SVN_PARAM=" -r ${VERSION} "
[ -z "${DOCKER_BUILD_ENABLED}" ] && echo '${DOCKER_BUILD_ENABLED}为空' && return 2

# 拉取代码
mkdir -p /tmp/${SVN_PULL_TIME}/ && \
  cd /tmp/${SVN_PULL_TIME}/ && \
  svn co http://${SVN_SERVER}/svn/ty/${RICHPAY_SVN_NAME} ${SVN_PARAM} && \
  mv ${RICHPAY_SVN_NAME} ${RICHPAY_NAME} && \
  rm -f ${RICHPAY_NAME}/logs/*

# 导入配置和key
\cp -rf /data/project/${RICHPAY_NAME}/static/*  ${RICHPAY_NAME}/ \
  && rm -rf ${RICHPAY_NAME}/.svn \
  && rm -rf /data/project/${RICHPAY_NAME}/docker/${RICHPAY_NAME}/ \
  && mv ${RICHPAY_NAME}/ /data/project/${RICHPAY_NAME}/docker/ \
  && cd /data/project/${RICHPAY_NAME}/docker/ \
  && echo '成功导入配置和key'

# 创建docker忽略文件
touch .dockerignore

# 生成docker构建文件
cat << EOF > Dockerfile && echo 'Dockerfile已写入'
FROM python-custom:3.6.5r
MAINTAINER wxb@rich-f.com
EXPOSE ${RICHPAY_PORT}
COPY . /project/
ENTRYPOINT /project/start.sh && tail -F /project/${RICHPAY_NAME}/gunicorn_error.log
EOF

# 生成启动文件
cat << EOF > start.sh && chmod 755 start.sh && echo 'start.sh已写入'
#!/bin/bash
gunicorn -c /project/run_${RICHPAY_NAME}.conf autoapp:app
EOF

# 生成gunicorn的配置文件
cat << EOF > run_${RICHPAY_NAME}.conf && echo "run_${RICHPAY_NAME}.conf已写入"
#!/usr/bin/env python3
chdir = '/project/${RICHPAY_NAME}/'   #gunicorn要切换到的目的工作目录
daemon = True                 #后台工作模式
bind = '0.0.0.0:${RICHPAY_PORT}'  #绑定ip和端口号
backlog = 2048                #监听队列
timeout = 30                  #超时
worker_class = 'gevent'       #使用gevent模式
workers = 8                   #进程数
loglevel = 'debug'                      #日志级别，这个日志级别指的是错误日志的级别
errorlog = "/project/${RICHPAY_NAME}/gunicorn_error.log"    #错误日志文件
accesslog = "/project/${RICHPAY_NAME}/gunicorn_access.log"  #访问日志文件
#设置gunicorn访问日志格式>，错误日志无法设置
access_log_format = '%(t)s %(p)s %(h)s "%(r)s" %(s)s %(L)s %(b)s %(f)s" "%(a)s"'
EOF

# 构建镜像
docker build -t ${RICHPAY_NAME}:${SVN_PULL_TIME} .

# 导出镜像
docker save ${RICHPAY_NAME}:${SVN_PULL_TIME} -o /data/images/save_${RICHPAY_NAME}_${SVN_PULL_TIME}.tar

# 把镜像同步到haproxy
for ip in ${SERVER_IP_LIST[@]}
do
  rsync -avz /data/images/save_${RICHPAY_NAME}_${SVN_PULL_TIME}.tar ${ip}:/data/images/
  ssh ${ip} "docker load -i /data/images/save_${RICHPAY_NAME}_${SVN_PULL_TIME}.tar"
done
