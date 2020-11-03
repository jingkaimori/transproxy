# 反代站安装脚本

这是在Linux服务器上搭建反代站点的脚本，__不适用于windows系统！不适用于个人电脑！__
## 依赖

一台暴露在公网上、有独立域名的Linux服务器，服务器上需要安装nginx和`acme.sh`
## 步骤

1. 安装nginx。
1. 安装`acme.sh`：
    ```bash
		wget -O -  https://get.acme.sh | sh
	```
1. 修改文件，用服务器域名替换掉该文件夹下所有文件中的`example.org`和`example\.org`
1. 使用[domain.zone](domain.zone)配置dns规则
1. 将此文件夹发送到服务器上，执行[安装脚本](install.sh)。

## CREDIT
本工程中0部分代码来自[Mashirozx的仓库](https://github.com/mashirozx/Pixiv-nginx)

## 参考
* ["https://2heng.xin/2017/09/19/pixiv/"](https://2heng.xin/2017/09/19/pixiv/)
* ["https://blog.sukiu.net/p/wikimirror.html"](https://blog.sukiu.net/p/wikimirror.html)反代wikipedia方法
* ["https://moe.best/technology/pixiv-proxy.html"](https://moe.best/technology/pixiv-proxy.html)反代pixiv方法