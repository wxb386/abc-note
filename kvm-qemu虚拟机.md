

### 1.准备工作

#### 1.1.模块
kvm_intel kvm_amd

#### 1.2.装包
```
# yum install qemu-kvm libvirt libvirt-client virt-install virt-manager virt-top virt-viewer
```

### 2.创建模板虚拟机系统

#### 2.1.配置网络
```
# vim vbr0.xml
  <network>
    <name>vbr0</name>
    <bridge name='vbr0' stp='on' delay='0'/>
    <forward mode='nat'/>
    <ip address='192.168.16.1' netmask='255.255.255.0'>
      <dhcp>
        <range start='192.168.16.100' end='192.168.16.199'/>
      </dhcp>
    </ip>
  </network>
# virsh <net-list | net-define | net-undefine | net-start | net-autostart | net-edit>
```
#### 2.2. 虚拟机配置文件
##### 2.2.1. 配置文件结构
##### 2.2.2. OS配置项
##### 2.2.3. CPU内存配置项
##### 2.2.4. OS配置项
##### 2.2.5. CPU内存配置项

#### 1.3. 关闭网络管理服务
```
# systemctl stop NetworkManager
# systemctl disable NetworkManager
```

#### 2.2.


### 3. 外网访问虚拟机的网络配置
#### 3.1. 网桥配置文件ifcfg-br0
```
# vim /etc/sysconfig/network-scripts/ifcfg-br0
NAME=br0
DEVICE=br0
TYPE=Bridge
NM_CONTROLLED=no
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.80.80  # 这是原先的IP地址
NETMASK=255.255.255.0
GATEWAY=192.168.80.1
DNS1=202.96.128.86
```
#### 3.2. 网卡配置文件ifcfg-eth0
```
# vim /etc/sysconfig/network-scripts/ifcfg-eth0
NAME=eth0
DEVICE=enp4s0
TYPE=Ethernet
NM_CONTROLLED=no
BOOTPROTO=static
ONBOOT=yes
BRIDGE=br0
```

### 4. 网卡绑定设置

#### 4.1. 网卡配置文件01
```
# vim /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
DEVICE=enp3s0
NAME=eth0
BOOTPROTO=static
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
```
#### 4.2. 网卡配置文件02
```
# vim /etc/sysconfig/network-scripts/ifcfg-eth1
TYPE=Ethernet
DEVICE=enp4s0
NAME=eth1
BOOTPROTO=static
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
```
#### 4.3. 网桥配置文件
```
# vim /etc/sysconfig/network-scripts/ifcfg-bond0
TYPE=Ethernet
DEVICE=bond0
BOOTPROTO=static
ONBOOT=yes
NM_CONTROLLED=no
IPADDR=192.168.80.80
NETMASK=255.255.255.0
GATEWAY=192.168.80.1
DNS1=202.96.128.86
```
