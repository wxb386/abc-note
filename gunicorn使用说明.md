### 启动:
```
nohup gunicorn -k gevent -w 8 -b 0.0.0.0:5000 start:app &
```

### 重启:
```
kill -1 主PID
```

### 使用环境变量配置:
```
GUNICORN_CMD_ARGS "--bind=127.0.0.1 --workers=3" 19.7.版本
```

在之前的文章中有记录WSGI容器的作用，以及我们知道常见的容器就只有的uWSGI和Gunicorn，在之前的文章中有记录他们的特性及优缺点，在这就不在多做描述。接下来将着重记录一下Gunicorn的一些配置：

- config
```
-c CONFIG, --config CONFIG
Gunicorn配置文件路径，路径形式的字符串格式，如：
gunicorn -c gunicorn.conf manager:app
```

- bind
```
-b ADDRESS, --bind ADDRESS
Gunicorn绑定服务器套接字，Host形式的字符串格式。Gunicorn可绑定多个套接字，如：
gunicorn -b 127.0.0.1:8000 -b [::1]:9000 manager:app
```


- backlog
```
--backlog
未决连接的最大数量，即等待服务的客户的数量。
必须是正整数，一般设定在64~2048的范围内，一般设置为2048，超过这个数字将导致客户端在尝试连接时错误
```

- workers
```
-w INT, --workers INT
用于处理工作进程的数量，为正整数，默认为1。
worker推荐的数量为当前的CPU个数*2 + 1。计算当前的CPU个数方法：
import multiprocessingprint multiprocessing.cpu_count()
```

- worker_class
```
-k STRTING, --worker-class STRTING
要使用的工作模式，默认为sync。
可引用以下常见类型“字符串”作为捆绑类：
sync
eventlet：需要下载eventlet>=0.9.7
gevent：需要下载gevent>=0.13
tornado：需要下载tornado>=0.2
gthread
gaiohttp：需要python 3.4和aiohttp>=0.21.5
```

- threads
```
--threads INT
处理请求的工作线程数，使用指定数量的线程运行每个worker。
为正整数，默认为1。
```

- worker_connections
```
--worker-connections INT
最大客户端并发数量，默认情况下这个值为1000。
此设置将影响gevent和eventlet工作模式
```

- max_requests
```
--max-requests INT
重新启动之前，工作将处理的最大请求数。
默认值为0。
```

- max_requests_jitter
```
--max-requests-jitter INT
要添加到max_requests的最大抖动。
抖动将导致每个工作的重启被随机化，这是为了避免所有工作被重启。
randint(0,max-requests-jitter)
```

- timeout
```
-t INT, --timeout INT
超过这么多秒后工作将被杀掉，并重新启动。一般设定为30秒
```

- graceful_timeout
```
--graceful-timeout INT
优雅的人工超时时间，默认情况下，这个值为30。
收到重启信号后，工作人员有那么多时间来完成服务请求。
在超时(从接收到重启信号开始)之后仍然活着的工作将被强行杀死。
```

- keepalive
```
--keep-alive INT
在keep-alive连接上等待请求的秒数，默认情况下值为2。
一般设定在1~5秒之间。
```

- limit_request_line
```
--limit-request-line INT
HTTP请求行的最大大小，此参数用于限制HTTP请求行的允许大小，默认情况下，这个值为4094。
值是0~8190的数字。此参数可以防止任何DDOS攻击
```

- limit_request_fields
```
--limit-request-fields INT
限制HTTP请求中请求头字段的数量。
此字段用于限制请求头字段的数量以防止DDOS攻击，与limit-request-field-size一起使用可以提高安全性。
默认情况下，这个值为100，这个值不能超过32768
```

- limit_request_field_size
```
--limit-request-field-size INT
限制HTTP请求中请求头的大小，默认情况下这个值为8190。
值是一个整数或者0，当该值为0时，表示将对请求头大小不做限制
```

- reload
```
--reload
代码更新时将重启工作，默认为False。
此设置用于开发，每当应用程序发生更改时，都会导致工作重新启动。
```

- reload_engine
```
--reload-engine STRTING
选择重载的引擎，支持的有三种：
auto
pull
inotity：需要下载
```

- spew
```
--spew
打印服务器执行过的每一条语句，默认False。
此选择为原子性的，即要么全部打印，要么全部不打印
```

- check_config
```
--check-config
显示现在的配置，默认值为False，即显示。
```

- preload_app
```
--preload
在工作进程被复制(派生)之前加载应用程序代码，默认为False。
通过预加载应用程序，你可以节省RAM资源，并且加快服务器启动时间。
```

- chdir
```
--chdir
加载应用程序之前将chdir目录指定到指定目录
```

- daemon
```
--daemon
守护Gunicorn进程，默认False
```

- raw_env
```
-e ENV, --env ENV
设置环境变量(key=value)，将变量传递给执行环境，如：
gunicorin -b 127.0.0.1:8000 -e abc=123 manager:app
在配置文件中写法：
raw_env=["abc=123"]
```

- pidfile
```
-p FILE, --pid FILE
设置pid文件的文件名，如果不设置将不会创建pid文件
```

- worker_tmp_dir
```
--worker-tmp-dir DIR
设置工作临时文件目录，如果不设置会采用默认值。
```

- accesslog
```
--access-logfile FILE
要写入的访问日志目录
```

- access_log_format
```
--access-logformat STRING
要写入的访问日志格式。如：
access_log_format = '%(h)s %(l)s %(u)s %(t)s'
1
常见格式说明：
```
识别码|说明
-|-
h|远程地址
l|“-“
u|用户名
t|时间
r|状态行，如：GET /test HTTP/1.1
m|请求方法
U|没有查询字符串的URL
q|查询字符串
H|协议
s|状态码
B|response长度
b|response长度(CLF格式)
f|参考
a|用户代理
T|请求时间，单位为s
D|请求时间，单位为ms
p|进程id
{Header}i|请求头
{Header}o|相应头
{Variable}e|环境变量

- errorlog
```
--error-logfile FILE, --log-file FILE
要写入错误日志的文件目录。
```

- loglevel
```
--log-level LEVEL
错误日志输出等级。
支持的级别名称为:
debug(调试)
info(信息)
warning(警告)
error(错误)
critical(危急)
```

