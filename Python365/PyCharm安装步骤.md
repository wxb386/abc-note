

1.从官网下载PyCharm社区版
```
# curl -O https://download.jetbrains.8686c.com/python/pycharm-community-2018.2.4.tar.gz
```

2.解压到工作目录
```
# tar -xvf pycharm-community-2018.2.4.tar.gz ./
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
