# Zabbix安装


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

