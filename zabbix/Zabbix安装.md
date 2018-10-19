# Zabbix安装

- 参考文档:`https://www.cnblogs.com/clsn/p/7885990.html`

**下载Zabbix源码包**
```
# mkdir -p /root/soft/ && cd /root/soft/
# curl -O https://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.0.0/zabbix-4.0.0.tar.gz
```

**创建用户**
```
# groupadd zabbix
# useradd -g zabbix zabbix
```

### Zabbix服务端 - Server

**编译安装**
```
# yum install gcc gcc-c++ make httpd php php-fpm mariadb-server mariadb-devel libxml2-devel pcre-devel libevent-devel libcurl-devel
# tar -xvf zabbix-4.0.0.tar.gz
# cd zabbix-4.0.0
# ./configure \
--prefix=/usr/local/zabbix \
--enable-server \
--enable-agent \
--with-mysql \
--with-libcurl \
--with-libxml2 \
--with-libpcre
# make -j4 && make install
```


### Zabbix代理端 - Agent
**编译安装**





---

yum源安装

1.yum配置

2.server端安装
```bash
# yum install zabbix30-server-mysql zabbix30-web-mysql zabbix30-dbfiles-mysql mariadb-server wqy-microhei-fonts
# systemctl start mariadb
# mysql -e 'create database zabbix character set utf8-mb4 collate utf8_bin;'
# mysql -e 'grant all privileges on zabbix.* to zabbix@localhost identified by "zabbix";'
# mysql -uzabbix -pzabbix zabbix < /usr/share/zabbix-mysql/schema.sql
# mysql -uzabbix -pzabbix zabbix < /usr/share/zabbix-mysql/images.sql
# mysql -uzabbix -pzabbix zabbix < /usr/share/zabbix-mysql/data.sql
# sed -ri 's,^# DBPassword.*,DBPassword=zabbix,' /etc/zabbix/zabbix_server.conf
# sed -ri '/.*date.timezone.*/s,# php_value.*,php_value date.timezone Asia/Shanghai,' /etc/httpd/conf.d/zabbix.conf
# \cp /usr/share/fonts/wqy-microhei/wqy-microhei.ttc /usr/share/fonts/dejavu/DejaVuSans.ttf
# systemctl start zabbix-server
# systemctl start httpd
# systemctl enable mariadb
# systemctl enable httpd
# systemctl enable zabbix-server-mysql

```

3.agent端安装
```
# yum install zabbix30-agent
# sed -ri -e 's,^Server=.*,Server=192.168.80.9,' \
-e 's,^ServerActive=.*,ServerActive=192.168.80.9,' \
-e 's,^Hostname=.*,Hostname=mongo11,' \
-e '/EnableRemoteCommands=.*/a EnableRemoteCommands=1' \
-e '/UnsafeUserParameters=.*/a UnsafeUserParameters=1' \
/etc/zabbix_agentd.conf
# systemctl start zabbix-agent
# systemctl enable zabbix-agent
```