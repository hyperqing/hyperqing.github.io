---
title: 使用 Hexo + Caddy 搭建博客
date: 2019-10-27 22:58:00
updated: 2019-10-28 00:10:00
tags: 
- 搭建博客
- Caddy
- Hexo
- Docker
categories: 
- [记事, 技术]
---

闲来没事，花点时间给自己搭个博客。

## Hexo

此前有了解过 [Hexo](https://hexo.io/zh-cn/) 静态博客生成工具，默认的主题就很不错了，立刻搞起。

<!-- more -->

参考文档进行安装使用：<https://hexo.io/zh-cn/docs/>

由于 Hexo 需要执行命令来生成静态文件，比较理想的方式应该是本地直接推代码到git，然后经过持续集成，自动执行命令生成文件后再推回到 Git，甚至直接推送到服务器等等。

我的博客就不搞这么高端了，于我而言就只是个博客而已。

我是这样管理博客代码的，以供参考：

- 在本地开发环境，基于`master`分支，创建一个分支`hexo`。
- 在`hexo`分支下执行命令生成静态文件。
```shell script
$ hexo generate
# 或
$ hexo g
```
- 提交`hexo`分支。
- 服务器拉取`hexo`分支即可。

这里我把项目当成纯静态网页文件来操作，不在服务器做生成工作。下面就来弄一个服务器软件，用来访问这个网页文件夹。

## Caddy Server

我选用了一款懒人必备的服务器软件 Caddy Server。在我编写本文时，已经发布了 Caddy Server2 的 Beta 版本，读者有兴趣的也可以试用一下。

它的一些特点让我非常钟情。

- 自动HTTPS
- 自动HTTP2
- 全功能HTTP
- 配置文件容易阅读和书写

尤其是自动HTTPS，对于个人站长来说是个非常便利的工具，只要域名能访问到服务器，它就能自动调用 Let's encrypt 的接口注册SSL证书，并自动启用433->80跳转。尽管每次注册都只有三个月有效期，但会自动更新证书，可谓方便至极。

下面展示的是本博客使用的配置示例：
```
domain.com, www.domain.com {
    log /var/log/caddy_logs/access.log
    errors /var/log/caddy_logs/errors.log

    gzip

    root /app/www.hyperqing.com
}
```

Caddy 官网有详细的配置书写格式说明，这里作简单说明。

- domain.com, www.domain.com: 没声明Schema和端口的情况下，默认同时支持HTTP/HTTPS，同时开启80和443端口。当前为两个域名指向同一个网站。
- log xxx.log: 访问日志文件。
- errros xxx.log: 错误日志文件。
- gzip: 开启 Gzip 压缩。
- root: 指明网站根目录。


**注意** 这里的网站根目录我省略了`public`目录，因为是使用 Docker 直接将public弄进容器里的，所以上述配置中不写`public`目录。对比本地开发时网站目录默认为`./public`。

**注意** 默认开启HTTPS功能，如果不需要，添加配置声明`tls off`，并在域名前面加上`http://`，限制只能通过HTTP方式访问，不支持HTTPS，也不会自动跳转到HTTPS。

## Docker

还是老样子，Docker搞起，方便管理容器和端口。配置涉及敏感路径就不贴了，具体配置看自己需要来操作。记得把证书通过volumns的方式弄到宿主机里保存，避免Docker容器重启后证书丢失（重复申请证书每周期内有次数和频率限制，具体见Let's encrypt官方说明）。

推荐镜像：`abiosoft/caddy:no-stats`

说明：no-stats是关闭了状态追踪的版本，文档对该功能描述不多，只是我认为我不需要用到就选择了关闭功能的版本，具体见Caddy官方文档。

文档：<https://hub.docker.com/r/abiosoft/caddy>


