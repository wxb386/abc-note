

1.从官网下载PyCharm社区版
```
curl -O
```

2.解压到工作目录
```

```

3.创建桌面图标
```
cat << . > /root/桌面/PyCharm.desktop
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
chmod 700 /root/桌面/PyCharm.desktop
```

