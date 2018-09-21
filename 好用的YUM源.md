## 1. 阿里云镜像
```
# curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

## 2. 163镜像
```
# curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
# rpm -Uvh \
  http://mirrors.163.com/rpmfusion/free/el/rpmfusion-free-release-7.noarch.rpm \
  http://mirrors.163.com/rpmfusion/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm
```

## 3. 其他镜像
```
# yum localinstall --nogpgcheck \
  https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
  https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm
```
