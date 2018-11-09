#!/bin/bash
#读入配置变量
source /data/project/var.sh
[ ! -z "${VERSION}" ] && SVN_PARAM=" -r ${VERSION} "
[ -z "${DOCKER_BUILD_ENABLED}" ] && echo '${DOCKER_BUILD_ENABLED}为空' && return 2
#拉取代码
mkdir -p /tmp/${SVN_PULL_TIME}/ && \
  cd /tmp/${SVN_PULL_TIME}/ && \
  svn co http://${SVN_SERVER}/svn/ty/${MONEY_SVN_NAME} ${SVN_PARAM} && \
  mv ${MONEY_SVN_NAME} ${MONEY_NAME} && \
  rm -f ${MONEY_NAME}/logs/*

#导入静态资源
\cp -rf ${MONEY_NAME}/richmoney/static/* /data/project/${MONEY_NAME}/static/static/ \
  && \cp -rf /data/project/${MONEY_NAME}/static/static/* ${MONEY_NAME}/richmoney/static/

#导入配置
\cp -f /data/project/${MONEY_NAME}/static/settings.py  ${MONEY_NAME}/richmoney/ \
  && sed -ri 's,^from PyQt5,#from PyQt5,' ${MONEY_NAME}/richmoney/food/printer_util.py \
  && rm -rf ${MONEY_NAME}/.[a-zA-Z]*/ \
  && rm -rf /data/project/${MONEY_NAME}/docker/${MONEY_NAME}/ \
  && mv ${MONEY_NAME}/ /data/project/${MONEY_NAME}/docker/${MONEY_NAME}/

#构建镜像
cd /data/project/${MONEY_NAME}/docker/ && touch .dockerignore
cat << . > Dockerfile
FROM python-custom:3.6.5r
MAINTAINER wxb@rich-f.com
EXPOSE ${MONEY_PORT1}
EXPOSE ${MONEY_PORT2}
COPY . /project/
ENTRYPOINT /project/start.sh && tail -F /project/${MONEY_NAME}/gunicorn_error.log
.
cat << . > start.sh && chmod 755 start.sh
#!/bin/bash
cd /project/money/
gunicorn -D -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker -w 1 --threads 16 -b 0.0.0.0:${MONEY_PORT1} --error-logfile /project/${MONEY_NAME}/gunicorn_error.log --log-level debug start:app
sleep 2
celery worker -D -A start.celery -c 8 -P gevent --loglevel=info
sleep 2
celery flower -D -A start.celery --address=0.0.0.0 --port=${MONEY_PORT2} --basic_auth=admin:richfadmin
.
docker build -t ${MONEY_NAME}:${SVN_PULL_TIME} .

#导出镜像
docker save ${MONEY_NAME}:${SVN_PULL_TIME} -o /data/images/save_${MONEY_NAME}_${SVN_PULL_TIME}.tar
