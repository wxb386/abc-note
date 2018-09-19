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
===

## 在之前的文章中有记录WSGI容器的作用，以及我们知道常见的容器就只有的uWSGI和Gunicorn，在之前的文章中有记录他们的特性及优缺点，在这就不在多做描述。接下来将着重记录一下Gunicorn的一些配置:
===

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

# 以下是未翻译版本
.. Please update gunicorn/config.py instead.

.. _settings:

Settings
========

This is an exhaustive list of settings for Gunicorn. Some settings are only
able to be set from a configuration file. The setting name is what should be
used in the configuration file. The command line arguments are listed as well
for reference on setting at the command line.

.. note::

    Settings can be specified by using environment variable
    ``GUNICORN_CMD_ARGS``. All available command line arguments can be used.
    For example, to specify the bind address and number of workers::

        $ GUNICORN_CMD_ARGS="--bind=127.0.0.1 --workers=3" gunicorn app:app

    .. versionadded:: 19.7

Config File
-----------

.. _config:

config
~~~~~~

* ``-c CONFIG, --config CONFIG``
* ``None``

The Gunicorn config file.

A string of the form ``PATH``, ``file:PATH``, or ``python:MODULE_NAME``.

Only has an effect when specified on the command line or as part of an
application specific configuration.

.. versionchanged:: 19.4
   Loading the config from a Python module requires the ``python:``
   prefix.

Debugging
---------

.. _reload:

reload
~~~~~~

* ``--reload``
* ``False``

Restart workers when code changes.

This setting is intended for development. It will cause workers to be
restarted whenever application code changes.

The reloader is incompatible with application preloading. When using a
paste configuration be sure that the server block does not import any
application code or the reload will not work as designed.

The default behavior is to attempt inotify with a fallback to file
system polling. Generally, inotify should be preferred if available
because it consumes less system resources.

.. note::
   In order to use the inotify reloader, you must have the ``inotify``
   package installed.

.. _reload-engine:

reload_engine
~~~~~~~~~~~~~

* ``--reload-engine STRING``
* ``auto``

The implementation that should be used to power :ref:`reload`.

Valid engines are:

* 'auto'
* 'poll'
* 'inotify' (requires inotify)

.. versionadded:: 19.7

.. _reload-extra-files:

reload_extra_files
~~~~~~~~~~~~~~~~~~

* ``--reload-extra-file FILES``
* ``[]``

Extends :ref:`reload` option to also watch and reload on additional files
(e.g., templates, configurations, specifications, etc.).

.. versionadded:: 19.8

.. _spew:

spew
~~~~

* ``--spew``
* ``False``

Install a trace function that spews every line executed by the server.

This is the nuclear option.

.. _check-config:

check_config
~~~~~~~~~~~~

* ``--check-config``
* ``False``

Check the configuration.

Logging
-------

.. _accesslog:

accesslog
~~~~~~~~~

* ``--access-logfile FILE``
* ``None``

The Access log file to write to.

``'-'`` means log to stdout.

.. _disable-redirect-access-to-syslog:

disable_redirect_access_to_syslog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* ``--disable-redirect-access-to-syslog``
* ``False``

Disable redirect access logs to syslog.

.. versionadded:: 19.8

.. _access-log-format:

access_log_format
~~~~~~~~~~~~~~~~~

* ``--access-logformat STRING``
* ``%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"``

The access log format.

===========  ===========
Identifier   Description
===========  ===========
h            remote address
l            ``'-'``
u            user name
t            date of the request
r            status line (e.g. ``GET / HTTP/1.1``)
m            request method
U            URL path without query string
q            query string
H            protocol
s            status
B            response length
b            response length or ``'-'`` (CLF format)
f            referer
a            user agent
T            request time in seconds
D            request time in microseconds
L            request time in decimal seconds
p            process ID
{Header}i    request header
{Header}o    response header
{Variable}e  environment variable
===========  ===========

.. _errorlog:

errorlog
~~~~~~~~

* ``--error-logfile FILE, --log-file FILE``
* ``-``

The Error log file to write to.

Using ``'-'`` for FILE makes gunicorn log to stderr.

.. versionchanged:: 19.2
   Log to stderr by default.

.. _loglevel:

loglevel
~~~~~~~~

* ``--log-level LEVEL``
* ``info``

The granularity of Error log outputs.

Valid level names are:

* debug
* info
* warning
* error
* critical

.. _capture-output:

capture_output
~~~~~~~~~~~~~~

* ``--capture-output``
* ``False``

Redirect stdout/stderr to specified file in :ref:`errorlog`.

.. versionadded:: 19.6

.. _logger-class:

logger_class
~~~~~~~~~~~~

* ``--logger-class STRING``
* ``gunicorn.glogging.Logger``

The logger you want to use to log events in Gunicorn.

The default class (``gunicorn.glogging.Logger``) handle most of
normal usages in logging. It provides error and access logging.

You can provide your own logger by giving Gunicorn a
Python path to a subclass like ``gunicorn.glogging.Logger``.

.. _logconfig:

logconfig
~~~~~~~~~

* ``--log-config FILE``
* ``None``

The log config file to use.
Gunicorn uses the standard Python logging module's Configuration
file format.

.. _logconfig-dict:

logconfig_dict
~~~~~~~~~~~~~~

* ``--log-config-dict``
* ``{}``

The log config dictionary to use, using the standard Python
logging module's dictionary configuration format. This option
takes precedence over the :ref:`logconfig` option, which uses the
older file configuration format.

Format: https://docs.python.org/3/library/logging.config.html#logging.config.dictConfig

.. versionadded:: 19.8

.. _syslog-addr:

syslog_addr
~~~~~~~~~~~

* ``--log-syslog-to SYSLOG_ADDR``
* ``unix:///var/run/syslog``

Address to send syslog messages.

Address is a string of the form:

* ``unix://PATH#TYPE`` : for unix domain socket. ``TYPE`` can be ``stream``
  for the stream driver or ``dgram`` for the dgram driver.
  ``stream`` is the default.
* ``udp://HOST:PORT`` : for UDP sockets
* ``tcp://HOST:PORT`` : for TCP sockets

.. _syslog:

syslog
~~~~~~

* ``--log-syslog``
* ``False``

Send *Gunicorn* logs to syslog.

.. versionchanged:: 19.8
   You can now disable sending access logs by using the
   :ref:`disable-redirect-access-to-syslog` setting.

.. _syslog-prefix:

syslog_prefix
~~~~~~~~~~~~~

* ``--log-syslog-prefix SYSLOG_PREFIX``
* ``None``

Makes Gunicorn use the parameter as program-name in the syslog entries.

All entries will be prefixed by ``gunicorn.<prefix>``. By default the
program name is the name of the process.

.. _syslog-facility:

syslog_facility
~~~~~~~~~~~~~~~

* ``--log-syslog-facility SYSLOG_FACILITY``
* ``user``

Syslog facility name

.. _enable-stdio-inheritance:

enable_stdio_inheritance
~~~~~~~~~~~~~~~~~~~~~~~~

* ``-R, --enable-stdio-inheritance``
* ``False``

Enable stdio inheritance.

Enable inheritance for stdio file descriptors in daemon mode.

Note: To disable the Python stdout buffering, you can to set the user
environment variable ``PYTHONUNBUFFERED`` .

.. _statsd-host:

statsd_host
~~~~~~~~~~~

* ``--statsd-host STATSD_ADDR``
* ``None``

``host:port`` of the statsd server to log to.

.. versionadded:: 19.1

.. _statsd-prefix:

statsd_prefix
~~~~~~~~~~~~~

* ``--statsd-prefix STATSD_PREFIX``
* ``(empty string)``

Prefix to use when emitting statsd metrics (a trailing ``.`` is added,
if not provided).

.. versionadded:: 19.2

Process Naming
--------------

.. _proc-name:

proc_name
~~~~~~~~~

* ``-n STRING, --name STRING``
* ``None``

A base to use with setproctitle for process naming.

This affects things like ``ps`` and ``top``. If you're going to be
running more than one instance of Gunicorn you'll probably want to set a
name to tell them apart. This requires that you install the setproctitle
module.

If not set, the *default_proc_name* setting will be used.

.. _default-proc-name:

default_proc_name
~~~~~~~~~~~~~~~~~

* ``gunicorn``

Internal setting that is adjusted for each type of application.

SSL
---

.. _keyfile:

keyfile
~~~~~~~

* ``--keyfile FILE``
* ``None``

SSL key file

.. _certfile:

certfile
~~~~~~~~

* ``--certfile FILE``
* ``None``

SSL certificate file

.. _ssl-version:

ssl_version
~~~~~~~~~~~

* ``--ssl-version``
* ``_SSLMethod.PROTOCOL_TLS``

SSL version to use (see stdlib ssl module's)

.. versionchanged:: 19.7
   The default value has been changed from ``ssl.PROTOCOL_TLSv1`` to
   ``ssl.PROTOCOL_SSLv23``.

.. _cert-reqs:

cert_reqs
~~~~~~~~~

* ``--cert-reqs``
* ``VerifyMode.CERT_NONE``

Whether client certificate is required (see stdlib ssl module's)

.. _ca-certs:

ca_certs
~~~~~~~~

* ``--ca-certs FILE``
* ``None``

CA certificates file

.. _suppress-ragged-eofs:

suppress_ragged_eofs
~~~~~~~~~~~~~~~~~~~~

* ``--suppress-ragged-eofs``
* ``True``

Suppress ragged EOFs (see stdlib ssl module's)

.. _do-handshake-on-connect:

do_handshake_on_connect
~~~~~~~~~~~~~~~~~~~~~~~

* ``--do-handshake-on-connect``
* ``False``

Whether to perform SSL handshake on socket connect (see stdlib ssl module's)

.. _ciphers:

ciphers
~~~~~~~

* ``--ciphers``
* ``TLSv1``

Ciphers to use (see stdlib ssl module's)

Security
--------

.. _limit-request-line:

limit_request_line
~~~~~~~~~~~~~~~~~~

* ``--limit-request-line INT``
* ``4094``

The maximum size of HTTP request line in bytes.

This parameter is used to limit the allowed size of a client's
HTTP request-line. Since the request-line consists of the HTTP
method, URI, and protocol version, this directive places a
restriction on the length of a request-URI allowed for a request
on the server. A server needs this value to be large enough to
hold any of its resource names, including any information that
might be passed in the query part of a GET request. Value is a number
from 0 (unlimited) to 8190.

This parameter can be used to prevent any DDOS attack.

.. _limit-request-fields:

limit_request_fields
~~~~~~~~~~~~~~~~~~~~

* ``--limit-request-fields INT``
* ``100``

Limit the number of HTTP headers fields in a request.

This parameter is used to limit the number of headers in a request to
prevent DDOS attack. Used with the *limit_request_field_size* it allows
more safety. By default this value is 100 and can't be larger than
32768.

.. _limit-request-field-size:

limit_request_field_size
~~~~~~~~~~~~~~~~~~~~~~~~

* ``--limit-request-field_size INT``
* ``8190``

Limit the allowed size of an HTTP request header field.

Value is a positive number or 0. Setting it to 0 will allow unlimited
header field sizes.

.. warning::
   Setting this parameter to a very high or unlimited value can open
   up for DDOS attacks.

Server Hooks
------------

.. _on-starting:

on_starting
~~~~~~~~~~~

*  ::

        def on_starting(server):
            pass

Called just before the master process is initialized.

The callable needs to accept a single instance variable for the Arbiter.

.. _on-reload:

on_reload
~~~~~~~~~

*  ::

        def on_reload(server):
            pass

Called to recycle workers during a reload via SIGHUP.

The callable needs to accept a single instance variable for the Arbiter.

.. _when-ready:

when_ready
~~~~~~~~~~

*  ::

        def when_ready(server):
            pass

Called just after the server is started.

The callable needs to accept a single instance variable for the Arbiter.

.. _pre-fork:

pre_fork
~~~~~~~~

*  ::

        def pre_fork(server, worker):
            pass

Called just before a worker is forked.

The callable needs to accept two instance variables for the Arbiter and
new Worker.

.. _post-fork:

post_fork
~~~~~~~~~

*  ::

        def post_fork(server, worker):
            pass

Called just after a worker has been forked.

The callable needs to accept two instance variables for the Arbiter and
new Worker.

.. _post-worker-init:

post_worker_init
~~~~~~~~~~~~~~~~

*  ::

        def post_worker_init(worker):
            pass

Called just after a worker has initialized the application.

The callable needs to accept one instance variable for the initialized
Worker.

.. _worker-int:

worker_int
~~~~~~~~~~

*  ::

        def worker_int(worker):
            pass

Called just after a worker exited on SIGINT or SIGQUIT.

The callable needs to accept one instance variable for the initialized
Worker.

.. _worker-abort:

worker_abort
~~~~~~~~~~~~

*  ::

        def worker_abort(worker):
            pass

Called when a worker received the SIGABRT signal.

This call generally happens on timeout.

The callable needs to accept one instance variable for the initialized
Worker.

.. _pre-exec:

pre_exec
~~~~~~~~

*  ::

        def pre_exec(server):
            pass

Called just before a new master process is forked.

The callable needs to accept a single instance variable for the Arbiter.

.. _pre-request:

pre_request
~~~~~~~~~~~

*  ::

        def pre_request(worker, req):
            worker.log.debug("%s %s" % (req.method, req.path))

Called just before a worker processes the request.

The callable needs to accept two instance variables for the Worker and
the Request.

.. _post-request:

post_request
~~~~~~~~~~~~

*  ::

        def post_request(worker, req, environ, resp):
            pass

Called after a worker processes the request.

The callable needs to accept two instance variables for the Worker and
the Request.

.. _child-exit:

child_exit
~~~~~~~~~~

*  ::

        def child_exit(server, worker):
            pass

Called just after a worker has been exited, in the master process.

The callable needs to accept two instance variables for the Arbiter and
the just-exited Worker.

.. versionadded:: 19.7

.. _worker-exit:

worker_exit
~~~~~~~~~~~

*  ::

        def worker_exit(server, worker):
            pass

Called just after a worker has been exited, in the worker process.

The callable needs to accept two instance variables for the Arbiter and
the just-exited Worker.

.. _nworkers-changed:

nworkers_changed
~~~~~~~~~~~~~~~~

*  ::

        def nworkers_changed(server, new_value, old_value):
            pass

Called just after *num_workers* has been changed.

The callable needs to accept an instance variable of the Arbiter and
two integers of number of workers after and before change.

If the number of workers is set for the first time, *old_value* would
be ``None``.

.. _on-exit:

on_exit
~~~~~~~

*  ::

        def on_exit(server):
            pass

Called just before exiting Gunicorn.

The callable needs to accept a single instance variable for the Arbiter.

Server Mechanics
----------------

.. _preload-app:

preload_app
~~~~~~~~~~~

* ``--preload``
* ``False``

Load application code before the worker processes are forked.

By preloading an application you can save some RAM resources as well as
speed up server boot times. Although, if you defer application loading
to each worker process, you can reload your application code easily by
restarting workers.

.. _sendfile:

sendfile
~~~~~~~~

* ``--no-sendfile``
* ``None``

Disables the use of ``sendfile()``.

If not set, the value of the ``SENDFILE`` environment variable is used
to enable or disable its usage.

.. versionadded:: 19.2
.. versionchanged:: 19.4
   Swapped ``--sendfile`` with ``--no-sendfile`` to actually allow
   disabling.
.. versionchanged:: 19.6
   added support for the ``SENDFILE`` environment variable

.. _reuse-port:

reuse_port
~~~~~~~~~~

* ``--reuse-port``
* ``False``

Set the ``SO_REUSEPORT`` flag on the listening socket.

.. versionadded:: 19.8

.. _chdir:

chdir
~~~~~

* ``--chdir``
* ``/usr/src/app``

Chdir to specified directory before apps loading.

.. _daemon:

daemon
~~~~~~

* ``-D, --daemon``
* ``False``

Daemonize the Gunicorn process.

Detaches the server from the controlling terminal and enters the
background.

.. _raw-env:

raw_env
~~~~~~~

* ``-e ENV, --env ENV``
* ``[]``

Set environment variable (key=value).

Pass variables to the execution environment. Ex.::

    $ gunicorn -b 127.0.0.1:8000 --env FOO=1 test:app

and test for the foo variable environment in your application.

.. _pidfile:

pidfile
~~~~~~~

* ``-p FILE, --pid FILE``
* ``None``

A filename to use for the PID file.

If not set, no PID file will be written.

.. _worker-tmp-dir:

worker_tmp_dir
~~~~~~~~~~~~~~

* ``--worker-tmp-dir DIR``
* ``None``

A directory to use for the worker heartbeat temporary file.

If not set, the default temporary directory will be used.

.. note::
   The current heartbeat system involves calling ``os.fchmod`` on
   temporary file handlers and may block a worker for arbitrary time
   if the directory is on a disk-backed filesystem.

   See :ref:`blocking-os-fchmod` for more detailed information
   and a solution for avoiding this problem.

.. _user:

user
~~~~

* ``-u USER, --user USER``
* ``501``

Switch worker processes to run as this user.

A valid user id (as an integer) or the name of a user that can be
retrieved with a call to ``pwd.getpwnam(value)`` or ``None`` to not
change the worker process user.

.. _group:

group
~~~~~

* ``-g GROUP, --group GROUP``
* ``20``

Switch worker process to run as this group.

A valid group id (as an integer) or the name of a user that can be
retrieved with a call to ``pwd.getgrnam(value)`` or ``None`` to not
change the worker processes group.

.. _umask:

umask
~~~~~

* ``-m INT, --umask INT``
* ``0``

A bit mask for the file mode on files written by Gunicorn.

Note that this affects unix socket permissions.

A valid value for the ``os.umask(mode)`` call or a string compatible
with ``int(value, 0)`` (``0`` means Python guesses the base, so values
like ``0``, ``0xFF``, ``0022`` are valid for decimal, hex, and octal
representations)

.. _initgroups:

initgroups
~~~~~~~~~~

* ``--initgroups``
* ``False``

If true, set the worker process's group access list with all of the
groups of which the specified username is a member, plus the specified
group id.

.. versionadded:: 19.7

.. _tmp-upload-dir:

tmp_upload_dir
~~~~~~~~~~~~~~

* ``None``

Directory to store temporary request data as they are read.

This may disappear in the near future.

This path should be writable by the process permissions set for Gunicorn
workers. If not specified, Gunicorn will choose a system generated
temporary directory.

.. _secure-scheme-headers:

secure_scheme_headers
~~~~~~~~~~~~~~~~~~~~~

* ``{'X-FORWARDED-PROTOCOL': 'ssl', 'X-FORWARDED-PROTO': 'https', 'X-FORWARDED-SSL': 'on'}``

A dictionary containing headers and values that the front-end proxy
uses to indicate HTTPS requests. These tell Gunicorn to set
``wsgi.url_scheme`` to ``https``, so your application can tell that the
request is secure.

The dictionary should map upper-case header names to exact string
values. The value comparisons are case-sensitive, unlike the header
names, so make sure they're exactly what your front-end proxy sends
when handling HTTPS requests.

It is important that your front-end proxy configuration ensures that
the headers defined here can not be passed directly from the client.

.. _forwarded-allow-ips:

forwarded_allow_ips
~~~~~~~~~~~~~~~~~~~

* ``--forwarded-allow-ips STRING``
* ``127.0.0.1``

Front-end's IPs from which allowed to handle set secure headers.
(comma separate).

Set to ``*`` to disable checking of Front-end IPs (useful for setups
where you don't know in advance the IP address of Front-end, but
you still trust the environment).

By default, the value of the ``FORWARDED_ALLOW_IPS`` environment
variable. If it is not defined, the default is ``"127.0.0.1"``.

.. _pythonpath:

pythonpath
~~~~~~~~~~

* ``--pythonpath STRING``
* ``None``

A comma-separated list of directories to add to the Python path.

e.g.
``'/home/djangoprojects/myproject,/home/python/mylibrary'``.

.. _paste:

paste
~~~~~

* ``--paste STRING, --paster STRING``
* ``None``

Load a PasteDeploy config file. The argument may contain a ``#``
symbol followed by the name of an app section from the config file,
e.g. ``production.ini#admin``.

At this time, using alternate server blocks is not supported. Use the
command line arguments to control server configuration instead.

.. _proxy-protocol:

proxy_protocol
~~~~~~~~~~~~~~

* ``--proxy-protocol``
* ``False``

Enable detect PROXY protocol (PROXY mode).

Allow using HTTP and Proxy together. It may be useful for work with
stunnel as HTTPS frontend and Gunicorn as HTTP server.

PROXY protocol: http://haproxy.1wt.eu/download/1.5/doc/proxy-protocol.txt

Example for stunnel config::

    [https]
    protocol = proxy
    accept  = 443
    connect = 80
    cert = /etc/ssl/certs/stunnel.pem
    key = /etc/ssl/certs/stunnel.key

.. _proxy-allow-ips:

proxy_allow_ips
~~~~~~~~~~~~~~~

* ``--proxy-allow-from``
* ``127.0.0.1``

Front-end's IPs from which allowed accept proxy requests (comma separate).

Set to ``*`` to disable checking of Front-end IPs (useful for setups
where you don't know in advance the IP address of Front-end, but
you still trust the environment)

.. _raw-paste-global-conf:

raw_paste_global_conf
~~~~~~~~~~~~~~~~~~~~~

* ``--paste-global CONF``
* ``[]``

Set a PasteDeploy global config variable in ``key=value`` form.

The option can be specified multiple times.

The variables are passed to the the PasteDeploy entrypoint. Example::

    $ gunicorn -b 127.0.0.1:8000 --paste development.ini --paste-global FOO=1 --paste-global BAR=2

.. versionadded:: 19.7

Server Socket
-------------

.. _bind:

bind
~~~~

* ``-b ADDRESS, --bind ADDRESS``
* ``['127.0.0.1:8000']``

The socket to bind.

A string of the form: ``HOST``, ``HOST:PORT``, ``unix:PATH``. An IP is
a valid ``HOST``.

Multiple addresses can be bound. ex.::

    $ gunicorn -b 127.0.0.1:8000 -b [::1]:8000 test:app

will bind the `test:app` application on localhost both on ipv6
and ipv4 interfaces.

.. _backlog:

backlog
~~~~~~~

* ``--backlog INT``
* ``2048``

The maximum number of pending connections.

This refers to the number of clients that can be waiting to be served.
Exceeding this number results in the client getting an error when
attempting to connect. It should only affect servers under significant
load.

Must be a positive integer. Generally set in the 64-2048 range.

Worker Processes
----------------

.. _workers:

workers
~~~~~~~

* ``-w INT, --workers INT``
* ``1``

The number of worker processes for handling requests.

A positive integer generally in the ``2-4 x $(NUM_CORES)`` range.
You'll want to vary this a bit to find the best for your particular
application's work load.

By default, the value of the ``WEB_CONCURRENCY`` environment variable.
If it is not defined, the default is ``1``.

.. _worker-class:

worker_class
~~~~~~~~~~~~

* ``-k STRING, --worker-class STRING``
* ``sync``

The type of workers to use.

The default class (``sync``) should handle most "normal" types of
workloads. You'll want to read :doc:`design` for information on when
you might want to choose one of the other worker classes. Required
libraries may be installed using setuptools' ``extra_require`` feature.

A string referring to one of the following bundled classes:

* ``sync``
* ``eventlet`` - Requires eventlet >= 0.9.7 (or install it via 
  ``pip install gunicorn[eventlet]``)
* ``gevent``   - Requires gevent >= 0.13 (or install it via 
  ``pip install gunicorn[gevent]``)
* ``tornado``  - Requires tornado >= 0.2 (or install it via 
  ``pip install gunicorn[tornado]``)
* ``gthread``  - Python 2 requires the futures package to be installed
  (or install it via ``pip install gunicorn[gthread]``)
* ``gaiohttp`` - Deprecated.

Optionally, you can provide your own worker by giving Gunicorn a
Python path to a subclass of ``gunicorn.workers.base.Worker``.
This alternative syntax will load the gevent class:
``gunicorn.workers.ggevent.GeventWorker``.

.. deprecated:: 19.8
   The ``gaiohttp`` worker is deprecated. Please use
   ``aiohttp.worker.GunicornWebWorker`` instead. See
   :ref:`asyncio-workers` for more information on how to use it.

.. _threads:

threads
~~~~~~~

* ``--threads INT``
* ``1``

The number of worker threads for handling requests.

Run each worker with the specified number of threads.

A positive integer generally in the ``2-4 x $(NUM_CORES)`` range.
You'll want to vary this a bit to find the best for your particular
application's work load.

If it is not defined, the default is ``1``.

This setting only affects the Gthread worker type.

.. note::
   If you try to use the ``sync`` worker type and set the ``threads``
   setting to more than 1, the ``gthread`` worker type will be used
   instead.

.. _worker-connections:

worker_connections
~~~~~~~~~~~~~~~~~~

* ``--worker-connections INT``
* ``1000``

The maximum number of simultaneous clients.

This setting only affects the Eventlet and Gevent worker types.

.. _max-requests:

max_requests
~~~~~~~~~~~~

* ``--max-requests INT``
* ``0``

The maximum number of requests a worker will process before restarting.

Any value greater than zero will limit the number of requests a work
will process before automatically restarting. This is a simple method
to help limit the damage of memory leaks.

If this is set to zero (the default) then the automatic worker
restarts are disabled.

.. _max-requests-jitter:

max_requests_jitter
~~~~~~~~~~~~~~~~~~~

* ``--max-requests-jitter INT``
* ``0``

The maximum jitter to add to the *max_requests* setting.

The jitter causes the restart per worker to be randomized by
``randint(0, max_requests_jitter)``. This is intended to stagger worker
restarts to avoid all workers restarting at the same time.

.. versionadded:: 19.2

.. _timeout:

timeout
~~~~~~~

* ``-t INT, --timeout INT``
* ``30``

Workers silent for more than this many seconds are killed and restarted.

Generally set to thirty seconds. Only set this noticeably higher if
you're sure of the repercussions for sync workers. For the non sync
workers it just means that the worker process is still communicating and
is not tied to the length of time required to handle a single request.

.. _graceful-timeout:

graceful_timeout
~~~~~~~~~~~~~~~~

* ``--graceful-timeout INT``
* ``30``

Timeout for graceful workers restart.

After receiving a restart signal, workers have this much time to finish
serving requests. Workers still alive after the timeout (starting from
the receipt of the restart signal) are force killed.

.. _keepalive:

keepalive
~~~~~~~~~

* ``--keep-alive INT``
* ``2``

The number of seconds to wait for requests on a Keep-Alive connection.

Generally set in the 1-5 seconds range for servers with direct connection
to the client (e.g. when you don't have separate load balancer). When
Gunicorn is deployed behind a load balancer, it often makes sense to
set this to a higher value.

.. note::
   ``sync`` worker does not support persistent connections and will
   ignore this option.


