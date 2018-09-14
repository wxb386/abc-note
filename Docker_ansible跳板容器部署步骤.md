## Docker_Ansible - 跳板容器部署步骤

### 1.下载依赖包
```
# mkdir -p /data/ansible/ && cd /data/ansible/
# echo '#!/bin/bash
    yum install --downloadonly \
        --downloaddir=/ansible/packet/ \
        ansible openssh-server openssh-clients' > download.sh \
	&& chmod 755 download.sh
# docker run --name ansible \
    -v /data/ansible/:/ansible/:rw \
    -v /etc/yum.repos.d/:/etc/yum.repos.d/:ro \
    -tid centos:7.5.1804 /ansible/download.sh \
    && docker logs -f ansible
```

### 2.编写启动脚本
```
# echo '#!/bin/bash
    yum -y install /ansible/packet/*.rpm
    echo docker | passwd --stdin root
    sed -ri -e 's,^#PermitEmptyPasswords.*,PermitEmptyPasswords no,' \
        -e 's,^PasswordAuthentication.*,PasswordAuthentication no,' \
        -e 's,^#ClientAliveInterval.*,ClientAliveInterval 60,' \
        -e 's,^#ClientAliveCountMax.*,ClientAliveCountMax 3,' \
        /etc/ssh/sshd_config;
    mkdir /root/.ssh/ && cp /ansible/ssh/* /root/.ssh/
    locale   ## 切记要执行这条指令,改变容器编码,使其支持中文/UTF-8
    /usr/sbin/sshd-keygen && /usr/sbin/sshd -D &
	tail -F /root/nohup.out' > start.sh && chmod 755 start.sh
```

### 3.启动容器
```
# iptables -A INPUT -p tcp -m tcp --dport 55555 -m state --state NEW -j ACCEPT
# docker run --name ansible -h ansible \
    -v /etc/localtime:/etc/localtime:ro \
    -v /data/ansible/conf/:/etc/ansible/:rw \
    -v /data/ansible/:/ansible/:rw \
    -p 55555:22/tcp \
    -e LANG="en_US.UTF-8" \
    -tid centos:7.5.1804 /ansible/start.sh \
    && docker logs -f ansible
```
### 4.远程连接
```
# ssh -p 55555 <ip>
```

### 5.总结

#### 5.1.中文显示问号问题
```
# 在容器启动命令加入环境变量
# -e LANG="en_US.UTF-8"
# 在启动文件中执行命令,使环境变量生效
# locale
```

#### 5.2.ssh密钥
```
# ssh-keygen
```

#### 5.3.常用的主机可以配置在/etc/hosts文件中
