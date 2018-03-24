---
layout: post
title: 在Nginx中配置Google-Analytics
date: 2018-03-23 18:27 +0800
tags:   Nginx
author: 月杪
---

#### 原因
在Nginx端配置Google-Analytics和在HTML中加载Google-Analytics有几个显著的有点,
1. 杜绝用户到Google Analytics之间的网络问题,特别是国内(尽管已经解析到Google在北京的服务器)
2. 防止adblock这样的软件屏蔽

#### 配置方法
nginx 配置 server 块内加入以下内容
```conf
userid on;
userid_name cid;
userid_domain moonagic.com;
userid_path /;
userid_expires max;
if ($http_accept_language ~* '^(.+?),') {
    set $first_language $1;
}

location @tracker {
    resolver 8.8.8.8 ipv6=off; # 需要设定dns,不然无法解析.不支持ipv6的机器需要关闭ipv6
    internal;
    proxy_method GET;
    proxy_pass https://www.google-analytics.com/collect?v=1&tid=UA-*******-*&$uid_set$uid_got&t=pageview&dh=$host&dp=$request_uri&uip=$remote_addr&dr=$http_referer&ul=$first_language&z=$msec;
    proxy_set_header User-Agent $http_user_agent;
    proxy_pass_request_headers off;
    proxy_pass_request_body off;
}
```

并在指向root或者bypass的时候添加
```conf
location / {
    root   /content/path/;
    post_action @tracker;
    ...
}
```
```conf
location / {
    proxy_pass http://127.0.0.1:8081;
    post_action @tracker;
    ...
 }
```
#### 后记
这样配置以后各种文件的访问都会被记录,其中就包括js,css,xml这种实际上我们不需要统计的访问.  
解决的办法也很简单,利用Nginx配置将这些静态资源的访问过滤掉就好.  
比如:
```conf
location ~ .*\.(css|js|ico|jpg|woff|png|txt|xml|ttf)$ {
    root   /content/path/;
    or
    proxy_pass http://127.0.0.1:8081;
}
```