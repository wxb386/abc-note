

1.从官网下载PyCharm社区版
```
# curl -O https://download.jetbrains.8686c.com/python/pycharm-community-2018.2.4.tar.gz
```

2.解压到工作目录
```
# tar -xvf pycharm-community-2018.2.4.tar.gz
```

3.创建桌面图标
```
# cat << . > /root/桌面/PyCharm.desktop
[Desktop Entry]
Type=Application
Name=Pycharm
GenericName=Pycharm3
Comment=Pycharm3:The Python IDE
Exec=/mnt/pycharm/bin/pycharm.sh
Icon=/mnt/pycharm/bin/pycharm.png
Terminal=pycharm
Categories=Pycharm
.
# chmod 700 /root/桌面/PyCharm.desktop
```

4.iBUs的相关配置
```
# cat << . >> /etc/profile
export IBUS_ENABLE_SYNC_MODE=1
.
```

5.一键安装脚本
```
# cat << . > one_key_install.sh
#!/bin/bash
mkdir -p /root/soft/
cd /root/soft/
curl -o pycharm.tar.gz \
https://download.jetbrains.8686c.com/python/pycharm-community-2018.2.4.tar.gz
tar -xvf pycharm.tar.gz
rm -rf /usr/local/pycharm
mv pycharm-community-2018.2.4 /usr/local/pycharm
cat << EOF > /root/桌面/PyCharm.desktop
[Desktop Entry]
Type=Application
Name=PyCharm
GenericName=PyCharm3
Comment=PyCharm3:The Python IDE
Exec=/usr/local/pycharm/bin/pycharm.sh
Icon=/usr/local/pycharm/bin/pycharm.png
Terminal=pycharm
Categories=PyCharm
EOF
chmod 700 /root/桌面/PyCharm.desktop
grep 'IBUS_ENABLE_SYNC_MODE=1' /etc/profile
if [ $? -ne 0 ]; then
cat << EOF >> /etc/profile
export IBUS_ENABLE_SYNC_MODE=1
EOF
fi
source /etc/profile
cd -
.
chmod 700 one_key_install.sh
```