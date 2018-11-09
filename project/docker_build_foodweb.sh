#!/bin/bash
#
# 1.读取配置文件
conf_file='var.sh'
if [ -f $conf_file ]; then
  source $conf_file
else
  return 1
fi

# 2.获取svn的版本号,若有版本号,则生成拉取参数
[ ! -z "${VERSION}" ] && SVN_PARAM=" -r ${VERSION} "

# 3.拉取代码
mkdir -p /tmp/${SVN_PULL_TIME}/ && \
  cd /tmp/${SVN_PULL_TIME}/ && \
  svn co http://${SVN_SERVER}/svn/ty/${FOOD_SVN_NAME} ${SVN_PARAM} && \
  mv ${FOOD_SVN_NAME} ${FOOD_NAME} && \
  rm -f ${FOOD_NAME}\logs\*
[ $? -ne 0 ] && echo "$? 拉取代码失败" && return 3

# 4.导入静态资源
\cp -rf ${FOOD_NAME}/richmoney/{static/,settings.py} /data/project/${FOOD_NAME}/static/ && \
  \cp -rf /data/project/${FOOD_NAME}/static/* ${FOOD_NAME}/richmoney/
[ $? -ne 0 ] && echo "$? 导入静态资源失败" && return 4

# 5.代码拷入构建目录
sed -ri 's,^from PyQt5,#from PyQt5,' ${FOOD_NAME}/richmoney/food/printer_util.py && \
  rm -rf /data/project/${FOOD_NAME}/docker/* && \
  mv ${FOOD_NAME}/ /data/project/${FOOD_NAME}/docker/ && \
  cd /data/project/${FOOD_NAME}/docker/
[ $? -ne 0 ] && echo "$? 代码拷入构建目录失败" && return 5

# 6.构建镜像
touch .dockerignore
cat << EOF > Dockerfile
FROM python-custom:3.6.5r
MAINTAINER wxb@rich-f.com
EXPOSE ${FOOD_PORT}
COPY . /project/
ENTRYPOINT /project/start.sh && tail -F /project/${FOOD_NAME}/gunicorn_error.log
EOF

cat << EOF > start.sh && chmod 755 start.sh
#!/bin/bash
cd /project/${FOOD_NAME}/
gunicorn -D -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 -b 0.0.0.0:${FOOD_PORT} --error-logfile /project/${FOOD_NAME}/gunicorn_error.log --log-level debug start:app
EOF

docker build -t ${FOOD_NAME}:${SVN_PULL_TIME} .
[ $? -ne 0 ] && echo "$? 构建镜像失败" && return 6

# 7.导出镜像
docker save ${FOOD_NAME}:${SVN_PULL_TIME} -o /data/images/save_${FOOD_NAME}_${SVN_PULL_TIME}.tar

echo "${FOOD_NAME}镜像构建完成,存储目录为/data/images/save_${FOOD_NAME}_${SVN_PULL_TIME}.tar"

