

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

#### 2.2.
