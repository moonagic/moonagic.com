---
layout: post
title: 利用Github的Webhook功能进行持续集成
date: 2018-04-09 20:23 +0800
tags:   VPS
author: 月杪
---

> [Webhook](https://developer.github.com/webhooks/),也就是人们常说的钩子,是一个很有用的工具.你可以通过定制Webhook来监测你在Github.com上的各种事件,最常见的莫过于push事件.如果你设置了一个监测push事件的Webhook,那么每当你的这个项目有了任何提交,这个Webhook都会被触发,这时Github就会发送一个POST请求到你配置好的地址.

这样你就可以通过这种方式去自动完成一些重复性工作.比如:你可以用Webhook来自动触发一些持续集成(CI)工具的运作.

Github开发者平台的文档中对Webhook的所能做的事是这样描述的：
> You’re only limited by your imagination.

Github Webhook和以前写过的[通过travis自动将Jekyll持续部署到服务器上](https://moonagic.com/auto-deploy-jekyll-with-travis/)相比:
* 不需要暴露(经过travis加密的)服务器私钥
* 不需要通过travis的虚拟机中转(那玩意儿的带宽实在是....)

当然和travis相比也有缺点:
* 需要有一台属于自己的外网服务器
* 自己的Webhook响应服务.

---

### 开始
要利用webhook进行持续集成工作至少需要以下几个条件:
* 可以外网访问的服务器
* 接收并响应GitHub Webhook的服务
* GitHub Webhook的配置

##### 服务器
还有什么好说的...
[如何选购VPS](https://moonagic.com/how-to-buy-vps/)

##### Webhook服务
Webhook支持服务很简单,甚至可以自己随手写一个,比如
```JavaScript
var http = require('http');
var exec = require('child_process').exec;
var createHandler = require('github-webhook-handler');

// '/auto_build' 和 'secretKey' 和下一步在GitHub中配置Webhook中的内容相同
var handler = createHandler({ path: '/auto_build', secret: 'secretKey' });
http.createServer(function (req, res) {
    handler(req, res, function (err) {
        res.statusCode = 404;
        res.end('no such location');
    })
}).listen(6606);

handler.on('error', function (err) {
    console.error('Error:', err.message)
});

handler.on('push', function (event) {
    console.log('Received a push event');
    // continuous_integration.sh 中是进行部署的动作
    exec("./continuous_integration.sh", function(err,stdout,stderr){
        if(err) {
            console.log('error:'+stderr);
        } else {
            console.log("stdout:"+stdout);
        }
    });
});
```
然后直接使用nodejs运行,在测试成功后让这个服务一直运行下去就好(使用forever或者systemd都可以).  
Webhook的原理就是当GitHub项目有需要监听的Event的时候向Webhook配置的地址发送请求,在Webhook响应服务上接收到请求后执行已经配置好的动作.
> 其实完全可以使用C/C++,Golang,java等语言写一个.不过对于这种几乎没有任何性能要求的服务nodejs确实优势太大了.

[示例代码](https://github.com/moonagic/WebhookExample/tree/master)

##### GitHub Webhook配置
在需要配置Webhook的GitHub项目的Settings-Webhooks,如图:
![](https://pic.moonagic.com/images/2018/04/webhook0.png)

### 运行
在GitHub上进行了上一步配置有的Event后GitHub自动发送的请求会显示在Webhooks页面,如图:
![](https://pic.moonagic.com/images/2018/04/webhook1.png)

图中前五次都为请求成功,而最新一次请求失败了.  
然后当Webhook支持服务中的动作完成后本次集成工作就结束了.
