简介vsftpd及搭建配置

一、简介

 FTP(文件传输协议)全称是：Very Secure FTP Server。   Vsftpd是linux类操作系统上运行的ftp服务器软件。 

vsftp提供三种登陆方式：1.匿名登录  2.本地用户登录  3.虚拟用户登录

vsftpd的特点：1.较高的安全性需求    2.带宽的限制    3.创建支持虚拟用户    4.支持IPV6    5.中等偏上的性能    6.可分配虚拟IP    7.高速

 

 Ftp会话时采用了两种通道：

 控制通道：与Ftp服务器进行沟通的通道，链接Ftp发送ftp指令都是通过控制通道来完成的。

 数据通道：数据通道和Ftp服务器进行文件传输或则列表的通道 

 

二、工作原理

  Ftp协议中控制连接均是由客户端发起，而数据连接有两种工作方式：Port和Pasv方式

 

  Port模式（主动模式）--> 默认

  Ftp客户端首先和Ftp server的tcp 21端口建立连接，通过这个通道发送命令，客户端要接受数据的时候在这个通道上发送Port命令，Port命令包含了客户端用什么端口（一个大于1024的端口）接受数据，在传送数据的时候，服务器端通过自己的TCP 20端口发送数据。这个时候数据连接由server向client建立一个连接。

 Port交互流程：

client端：client链接server的21端口，并发送用户名密码和一个随机在1024上的端口及port命令给server，表明采用主动模式，并开放那个随机的端口。

server端：server收到client发来的Port主动模式命令与端口后，会通过自己的20端口与client那个随机的端口连接后，进行数据传输。

 

  Pasv模式（被动方式）

  建立控制通道和Port模式类似，当客户端通过这个通道发送Pasv命令的时候，Ftp server打开了一个位于1024和5000之间的随机端口并且通知客户端在这个端口上进行传输数据请求，然后Ftp server将通过这个端口进行数据传输。这个时候数据连接由client向server建立连接。

  Pasv交互流程

Clietn：client连接server的21号端口，发送用户名密码及pasv命令给server，表明采用被动模式。

server：server收到client发来的pasv被动模式命令之后，把随机开放在1024上的端口告诉client，client再用自己的20 端口与server的那个随机端口进行连接后进行数据传输。

 

  如果从C/S模型这个角度来说，PORT对于服务器来说是OUTBOUND，而PASV模式对于服务器是INBOUND，这一点请特别注意，尤其是在使用防火墙的企业里，这一点非常关键，如果设置错了，那么客户将无法连接。

 

三、安装vsftpd及相关软件

yum -y install vsftpd*  pam*   db4*

vsftpd：ftp软件      pam：认证模块       DB4：支持文件数据库

 

四、vsftpd的用户管理：

   FTP服务器对用户的管理，在默认的情况下是根据“ /etc/passwd系统用户配置文件” 及 “/etc/group系统用户组配置文件” 来进行配置。

   在FTP服务器中，匿名用户的用户名和密码都是ftp ；这个用户可以在您的操作系统中的 /etc/passwd 中能找得到；如：

ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
在ftp用户这行中，我们看到七个字段，每个字段写字段之间用:号分割；

1.ftp 是用户名

2.x 是密码字段，隐藏的

3.14 是用户的UID字段，可以自己来设定，不要和其它用户的UID相同，否则会造成系统安全问题；

4.50 用用户组的GID，可以自己设定，不要和其它用户组共用FTP的GID，否则会造成系统全全问题；

5.FTP User 是用户说明字段

6./var/ftp 是ftp用户的家目录，可以自己来定义

7./sbin/nologin 这是用户登录SHELL ，这个也是可以定义的，/sbin/nologin 表示不能登录系统；系统虚拟帐号（也被称为伪用户）一般都是这么设置。比如我们把ftp用户的/sbin/nologin 改为 /bin/bash ，这样ftp用户通过本地或者远程工具ssh或telnet以真实用户身份登录到系统。这样做对系统来说是不安全的；如果您认为一个用户没有太大的必要登录到系统，就可以只给他FTP帐号的权限，也就是说只给他FTP的权限，而不要把他的SHELL设置成 /bin/bash 等

 

匿名用户的属组:/etc/group

ftp:x:50:
第一个字段为：ftp:用户组、第二个字段为：x:密码段、第三个字段为：50:GID

可以根据对比用户配置文件以及用户组配置文件中的UID得知 是否为隶属关系。

 

五、vsftpd的配置

）因为vsftpd默认的宿主用户是root，不符合安全性要求，所以将新建立的vsftpd服务的宿主用户的shell改为“ /sbin/nologin意思是禁止登录系统 ”：useradd vsftpd -s /sbin/nologin

 

2.）建立vsftpd虚拟宿主用户:useradd virtusers  -s /sbin/nologin

此次主要介绍虚拟用户，顾名思义虚拟用户在系统中是不纯在的，它们集体寄托于方才创建的“virtusers”用户，那么这个用户就相当于一个虚拟用户组了，因为这个用户的权限将影响到后续讲到的虚拟用户。

 

3.）调整vsftpd的配置文件（编辑所有的配置文件前最好养成备份的习惯）

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.backup.conf

vim /etc/vsftpd/vsftpd.conf

按 Ctrl+C 复制代码

#设置为NO代表不允许匿名
anonymous_enable=YES
 
#设定本地用户可以访问，主要是虚拟宿主用户，如果设为NO那么所欲虚拟用户将无法访问。
local_enable=YES
 
#可以进行写的操作
write_enable=YES
 
#设定上传文件的权限掩码
local_umask=022
 
#禁止匿名用户上传
anon_upload_enable=NO
 
#禁止匿名用户建立目录
anon_mkdir_write_enable=NO
 
# 设定开启目录标语功能
dirmessage_enable=YES
 
# 设定开启日志记录功能
xferlog_enable=YES
 
#设定端口20进行数据连接
connect_from_port_20=YES
 
#设定禁止上传文件更改宿主
chown_uploads=NO
 
#设定vsftpd服务日志保存路劲。注意：改文件默认不纯在，需手动touch，且由于这里更改了vsftpd服务的宿主用户为手动建立的vsftpd，则必
须注意给予该用户对日志的读取权限否则服务启动失败。
xferlog_file=/var/log/vsftpd.log
 
#设定日志使用标准的记录格式
xferlog_std_format=YES
 
#设定空闲链接超时时间，这里使用默认/秒。
#idle_session_timeout=600
 
#设定最大连接传输时间，这里使用默认，将具体数值留给每个用户具体制定，默认120/秒
data_connection_timeout=3600
 
#设定支撑vsftpd服务的宿主用户为手动建立的vsftpd用户。注意：一旦更改宿主用户，需一起与该服务相关的读写文件的读写赋权问题.
nopriv_user=vsftpd
 
#设定支持异步传输的功能
#async_abor_enable=YES
 
#设置vsftpd的登陆标语
ftpd_banner=hello 欢迎登陆
 
#禁止用户登出自己的ftp主目录
chroot_list_enable=NO
 
#禁止用户登陆ftp后使用ls -R 命令。该命令会对服务器性能造成巨大开销，如果该项运行当多个用户使用该命令会对服务器造成威胁。
ls_recurse_enable=NO
 
#设定vsftpd服务工作在standalone模式下。所谓standalone模式就是该服务拥有自己的守护进程，在ps -A可以看出vsftpd的守护进程名。如果
不想工作在standalone模式下，可以选择SuperDaemon模式，注释掉即可，在该模式下vsftpd将没有自己的守护进程，而是由超级守护进程Xinetd全权代理，>与此同时，vsftpd服务的许多功能，将得不到实现。
listen=YES
 
#设定userlist_file中的用户将不能使用ftp
userlist_enable=YES
 
 
#设定pam服务下的vsftpd验证配置文件名。因此，PAM验证将参考/etc/pam.d/下的vsftpd文件配置。
pam_service_name=vsftpd
 
#设定支持TCPwrappers
tcp_wrappers=YES
 
#################################################以下是关于虚拟用户支持的重要配置项目，默认.conf配置文件中是不包含这些项目的，需手动添加。
#启用虚拟用户功能
guest_enable=YES
 
#指定虚拟的宿主用户
guest_username=virtusers
 
#设定虚拟用户的权限符合他们的宿主用户
virtual_use_local_privs=YES
 
#设定虚拟用户个人vsftp的配置文件存放路劲。这个被指定的目录里，将被存放每个虚拟用户个性的配置文件，注意的地方是：配置文件名必须
和虚拟用户名相同。
user_config_dir=/etc/vsftpd/vconf
 
#禁止反向域名解析，若是没有添加这个参数可能会出现用户登陆较慢，或则客户链接不上ftp的现象
reverse_lookup_enable=NO
按 Ctrl+C 复制代码
 

 

4.）建立vsftpd的日志文件，并更改属主为vsftpd的服务宿主用户

touch /var/log/vsftpd.log

chown vsftpd.vsftpd /var/log/vsftpd.log

 

六、配置虚拟用户

1.)建立虚拟用户配置文件的存放路径

mkdir /etc/vsftpd/vconf/

2.)建立一个虚拟用户名单文件，用来记录虚拟用户的账号和密码,格式为：一行用户名，一行密码。

vim /opt/vsftp/passwd

test
123456
test1
654321
3.）生成虚拟用户数据文件

db_load -T -t hash -f   /opt/vsftp/passwd  /opt/vsftp/passwd.db

需要注意的是，以后对虚拟用户的增删操作完之后需要再次执行上述命令，使其生成新的数据文件。

 

七、设置PAM验证文件，并制定虚拟用户数据库文件进行读取

对原验证文件备份后进行更改：cp /etc/pam.d/vsftpd   /etc/pam.d/vsftpd.backup

cat /etc/pam.d/vsftpd

复制代码
#%PAM-1.0
#####32位系统配置
#auth    sufficient      /lib/security/pam_userdb.so     db=/etc/vsftpd/xnpasswd
#account sufficient      /lib/security/pam_userdb.so     db=/etc/vsftpd/xnpasswd
#####64位系统配置
auth    sufficient      /lib64/security/pam_userdb.so     db=/opt/vsftp/passwd
account sufficient      /lib64/security/pam_userdb.so     db=/opt/vsftp/passwd

#以上两条是手动添加的，内容是对虚拟用户的安全和帐户权限进行验证。
#这里的auth是指对用户的用户名口令进行验证。
#这里的accout是指对用户的帐户有哪些权限哪些限制进行验证。
auth       required     pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
auth       required     pam_shells.so
auth       include      system-auth
account    include      system-auth
session    include      system-auth
session    required     pam_loginuid.so
复制代码
 

 

八、虚拟用户的配置

1.）定制虚拟用户模板配置文件（虚拟用户的配置文件名需要和虚拟用户一致，因为在登录ftp时输入相应的用户名之后会根据名称去加载相应的配置文件）

vim /etc/vsftpd/vconf/test

复制代码
local_root=/opt/vsftp/file
#指定虚拟用户仓库的具路径
anonymous_enable=NO
#设定不允许匿名访问
write_enable=YES
#允许写的操作
local_umask=022
#上传文件的权限掩码
anon_upload_enable=NO
#不允许匿名上传
anon_mkdir_write_enable=NO
#不允许匿名用户建立目录
idle_session_timeout=300
#设定空闲链接超时时间
data_connection_timeout=1000
#设定单次传输最大时间
max_clients=0
#设定并发客户端的访问数量
max_per_ip=0
#设定客户端的最大线程数
local_max_rate=0
#设定用户的最大传输速率，单位b/s
复制代码
 

2.）建立虚拟用户的仓库目录并更改相应属主/组且赋予相应权限

mkdir -p /opt/vsftpd/file

chown virtusers:virtusers /opt/vsftpd/file

chmod 755 /opt/vsftpd/file

 

3.）随便建立个文件方便后续检测是否安装成功：touch  /opt/vsftpd/file/abc

 

九、启动方式

ftp守护进程的启动方式有两种，standalone和(xinetd/inetd)

1.）xinetd模式：大多数较新的系统采用的是xinetd超级服务守护进程，它是inetd（因特网守护进程）的替代品。在linux中一些不主要的服务，并没有作为单独的守护进程在开机时启动，而是将他们的监听端口交给一个独立的进程xinetd集中监听，当收到客户端的请求之后，xinted进程就临时启动相应服务器并把端口移交给相应的服务，客户端断开之后，相应的服务进程结束，xinetd继续监听。

有的系统可能会需要安装xinetd：yum install xinetd

若是在/etc/xinetd.d/中没有vsftpd则需要新建，并添加如下内容：

复制代码
service ftp  
 
{  

socket_type = stream 
 
wait = no 
 
user = root 
 
server = /usr/sbin/vsftpd  
 
 
nice = 10 
 
disable = no 

} 
复制代码
释掉”/etc/vsftpd.conf“中的listen=YES之后重启，以xinetd启动  /etc/rc.d/init.d/xinetd restart

 

2.）standalone模式：运行期间一直驻留在内存中，对接入信号反应较快但是占用了些系统资源，因此常常用于需求较高的服务。

standalone模式运行ftp：

此模式便于实现PAM验证功能，进入这种模式首先关闭xinetd下的vsftpd，设置”disable=yes“，或则注释掉/etc/initd.conf中的相应的行，然后取消/etc/vsftpd/vsftpd.conf中listen=YES的注释。

启动：service vsftpd restart

 

 

十、从其他机器登陆ftp进行测试

建议关闭iptables 与 selinux 进行测试。

#需要先下载客户端 yum -y install ftp

Name (192.168.1.67:root):test
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
227 Entering Passive Mode (192,168,1,67,23,40).
150 Here comes the directory listing.
-rwxr-xr-x 2 500 500 4096 May 05 03:53 abc
226 Directory send OK.


可能会出现的错误：

1.）500 OOPS:错误

有可能是你的vsftpd.con配置文件中有不能被实别的命令，还有一种可能是命令的YES 或 NO 后面有空格

2.）若是提示权限问题，检测配置文件无误后执行：setsebool -P ftp_home_dir=1

vsftpd 对于权限的要求并不严格，对于指定ftp的宿主用户vsftpd也只是需要有日志文件的权限，其他地方默认即可，而虚拟用户的宿主则需要有相关的虚拟用户仓库路径的权限，且新版本下针对仓库的上级目录貌似不能是777权限可以是755
