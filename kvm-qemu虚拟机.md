
### 1.准备工作
#### 1.1.配置网络
  '''xml
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
  '''
