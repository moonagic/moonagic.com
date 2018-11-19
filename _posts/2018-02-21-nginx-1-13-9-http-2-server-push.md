---
layout: post
title: Nginx 1.13.9 HTTP/2 server push 介绍
date: 2018-02-21 12:13 +0800
tags:   Nginx
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

2018年2月20日发布的[NGINX 1.13.9](http://nginx.org/en/download.html)开始支持HTTP/2服务器推送功能.

[HTTP/2规范](https://tools.ietf.org/html/rfc7540#section-8.2)中定义的服务器推送允许服务器抢先将资源推送到远程客户端,预计客户端可能很快会请求这些资源.通过这样做,您可以在页面加载操作中将RTT(往返时间 - 请求和响应所需的时间)减少一个RTT或更多,从而为用户提供更快的响应.

### 配置HTTP/2 server push
```conf
server {
    # Ensure that HTTP/2 is enabled for the server
    listen 443 ssl http2;

    ssl_certificate ssl/certificate.pem;
    ssl_certificate_key ssl/key.pem;


    root /var/www/html;


    # whenever a client requests demo.html, also push
    # /style.css, /image1.jpg and /image2.jpg
    location = /demo.html {
        http2_push /style.css;
        http2_push /image1.jpg;
        http2_push /image2.jpg;
    }
}
```


### 验证HTTP/2 server push

* 使用开发人员工具进行验证(Google Chrome)

<picture>
  <source srcset="/images/2018/02/http2-server-push-chrome-screenshot.webp" type="image/webp">
  <img src="/images/2018/02/http2-server-push-chrome-screenshot.png" alt="">
</picture>

* 使用命令行客户端进行验证(nghttp)

```zsh
# *表示服务器推送的资源
$ nghttp -ans https://example.com/demo.html
id  responseEnd requestStart  process code size request path
 13    +84.25ms       +136us  84.11ms  200  492 /demo.html
  2    +84.33ms *   +84.09ms    246us  200  266 /style.css
  4   +261.94ms *   +84.12ms 177.83ms  200  40K /image2.jpg
  6   +685.95ms *   +84.12ms 601.82ms  200 173K /image1.jpg
```