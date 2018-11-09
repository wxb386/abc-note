#!/bin/bash
#
# 1.读取配置文件
conf_file='var.sh'
if [ -f $conf_file ]; then
  source $conf_file
else
  echo "$? 读取配置文件失败" && return 1
fi

# 2.获取svn的版本号,若有版本号,则生成拉取参数
[ ! -z "${VERSION}" ] && SVN_PARAM=" -r ${VERSION} "

# 3.拉取代码
mkdir -p /tmp/${SVN_PULL_TIME}/ && \
  cd /tmp/${SVN_PULL_TIME}/ && \
  svn co http://${SVN_SERVER}/svn/ty/${BCH_SVN_NAME} ${SVN_PARAM} && \
  mv ${BCH_SVN_NAME} ${BCH_NAME} && \
  rm -f ${BCH_NAME}\logs\*
[ $? -ne 0 ] && echo "$? 拉取代码失败" && return 3

# 4.代码拷入构建目录
rm -rf /data/project/${BCH_NAME}/docker/* \
  && mv ${BCH_NAME}/ /data/project/${BCH_NAME}/docker/ \
  && cd /data/project/${BCH_NAME}/docker/
[ $? -ne 0 ] && echo "$? 代码拷入构建目录失败" && return 4

# 5.构建镜像
touch .dockerignore

cat << EOF > requirements.txt
flask-mongoengine==0.9.5
Flask-PyMongo==2.1.0
Flask-Security==3.0.0
rocketchat-API==0.6.22
EOF

cat << EOF > Dockerfile
FROM python-custom:3.6.5r
MAINTAINER wxb@rich-f.com
EXPOSE ${BCH_PORT}
COPY . /project/
RUN pip install -r /project/requirements.txt
ENTRYPOINT /project/start.sh && tail -F /project/${BCH_NAME}/gunicorn_error.log
EOF

cat << EOF > start.sh && chmod 755 start.sh
#!/bin/bash
cd /project/${BCH_NAME}/ && \
gunicorn -D -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 -b 0.0.0.0:${BCH_PORT} --error-logfile /project/${BCH_NAME}/gunicorn_error.log --log-level debug start:app
EOF

docker build -t ${BCH_NAME}:${SVN_PULL_TIME} .

# 7.导出镜像
docker save ${BCH_NAME}:${SVN_PULL_TIME} -o /data/images/save_${BCH_NAME}_${SVN_PULL_TIME}.tar

echo "${BCH_NAME}镜像构建完成,存储目录为/data/images/save_${BCH_NAME}_${SVN_PULL_TIME}.tar"

