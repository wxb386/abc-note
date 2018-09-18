
# 1. 装包
```
# yum install samba
```
# 2. 配置
```
# mkdir -p /data/samba/
# vim /etc/samba/smb.conf
[samba]
path = /data/samba/
public = yes
browseable = yes
write list = zawn
valid users = zawn
# useradd -s /sbin/nologin zawn
# pdbedit -a zawn
```
# 3. 起服务
```
# systemctl enable smb
# systemctl start smb
```
# 4. 安全策略
```

```
