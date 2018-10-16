**1.下载源码**
```
# cd /root/soft/
# curl -O https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz
```

**2.编译安装**
```
# tar -xf Python-3.6.5.tar.xz
# cd Python-3.6.5/
# /usr/local/python3
# ./configure --prefix=/usr/local/python3 --enable-shared
# make -j4 && make install
# ln -s /usr/local/python3/bin/python3.6 /usr/bin/python3
# ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
```

**3.添加库目录**
```
# cat << . > /etc/ld.so.conf.d/python3.conf
/usr/local/python3/lib/
.
# ldconfig
```

**4.添加阿里云的pypi**
```
# mkdir -p /root/.pip/pip.conf
# cat << . > /root/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
.
```

**5.验证**
```
# python3 --version
```

**6.一键安装脚本**
```
# cat << . > one_key_python_365.sh && chmod 700 one_key_python_365.sh
#!/bin/bash
mkdir -p /root/soft/ && cd /root/soft/
yum -y install gcc gcc-c++ zlib-devel openssl-devel readline-devel libffi-devel sqlite-devel make
curl -O https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz \
&& tar -xf Python-3.6.5.tar.xz \
&& cd Python-3.6.5/ \
&& ./configure --prefix=/usr/local/python3 --enable-shared \
&& make -j4 \
&& make install \
&& ln -s /usr/local/python3/bin/python3.6 /usr/bin/python3 \
&& ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
cat << EOF > /etc/ld.so.conf.d/python3.conf && ldconfig
/usr/local/python3/lib/
EOF
mkdir -p /root/.pip/
cat << EOF > /root/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
EOF
pip3 install virtualenv==15.2.0
python3 --version && echo '安装完成.'
.
```
