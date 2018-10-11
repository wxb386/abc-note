# 安装pip3和virtualenv

**pip3安装**

在Python中，安装第三方模块，是通过包管理工具pip完成的。

- 官网:`https://pip.pypa.io/en/stable/installing/`

- pip依赖于setuptools和wheel,安装时会一起安装

- 下载安装脚本:`curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py`

- 运行安装脚本:`python3 get-pip.py`

- pip3的使用:
  1.安装:`pip3 install <包名>==<版本号> | -r <依赖清单>`
  2.下载:`pip3 download <包名>==<版本号> | -r <依赖清单>`
  3.导出依赖清单:`pip3 freeze > <依赖清单>`

- 模块搜索路径
默认情况下，Python解释器会搜索当前目录、所有已安装的内置模块和第三方模块，搜索路径存放在sys模块的path变量中
  1.直接添加到sys.path中:`sys.path.append('<新目录>')`
  2.环境变量PYTHONPATH

**virtualenv安装**

virtualenv为应用提供了隔离的Python运行环境，解决了不同应用间多版本的冲突问题。

- 安装virtualenv:`pip3 install virtualenv`

- 创建独立的Python运行环境:`virtualenv -p /usr/local/bin/python3 --no-site-packages <环境命名>`

- 新建的环境在当前目录的`<环境命名>`目录下

- 进入环境:`source <环境命名>/bin/activate`

- 在环境中可以`pip3`和`python3`

- 退出环境:`deactivate`