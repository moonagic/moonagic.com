---
layout: post
title: 用Golang写了一个Github webhook后台服务
date: 2018-05-24 12:46 +0800
tags:   Github
author: 月杪
---


前段时间写过一篇[利用Github的Webhook功能进行持续集成](https://moonagic.com/continuous-integration-with-github-webhook/),  
当时使用nodejs来写了webhook的后台服务.  
那个程序已经稳定运行了一段时间,期间并没有出现大的问题.  
但是毕竟是js的程序,空转状态就需要占用几十Mb的内存,就一个HTTP监听占用这么大确定不是开玩笑???  
另外一个问题就是该程序跑起来以后在Linux里会是一个node进程,这个时候如果你的服务器上同时运行了好几个由nodejs驱动的程序的话..

于是决定用go来重新实现这个工具,基本是完全复刻旧的nodejs项目然后添加了配置文件功能.  
[GoWebhook](https://github.com/moonagic/GoWebhook)

服务重新跑起来了,内存占用大概只有nodejs项目的**八分之一到十分之一**.  
并且后台也不会显示一个node进程了.