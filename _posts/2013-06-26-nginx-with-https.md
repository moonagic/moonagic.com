---
layout: post
title:  Nginx配置HTTPS加密
date:   2013-06-17
tags:   Nginx, SSL
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

```bash
# 建立保存目录
mkdir /etc/cert
cd /etc/cert
# 生成1024位加密的服务器私钥
openssl genrsa -out decode.li.key 1024
# 制作CSR证书申请文件
openssl req -new -key decode.li.key -out decode.li.csr

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [GB]:CN
State or Province Name (full name) [Berkshire]:Chongqing
Locality Name (eg, city) [Newbury]:Chongqing
Organization Name (eg, company) [My Company Ltd]:Vinoach
Organizational Unit Name (eg, section) []:Vinoach
Common Name (eg, your name or your server's hostname) []:www.vinoach.com

Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request

A challenge password []:
An optional company name []:
# 如果这里填写完整的话生成的csr文件是可以用来给证书机构生成商业证书的
```
如果自己生成未验证证书的话
```bash
openssl x509 -req -days 3650 -in vinoach.com.csr -signkey vinoach.key -out vinoach.crt
```
现在我们自己的crt证书就生成了

下面是nginx下网页实现ssl加密的配置参考
```bash
# HTTPS server
server {
    listen 443;
    server_name www.example.com;(你要加密的域名)

    ssl on;
    ssl_certificate /etc/cert/example.crt;(相应的文件位置)
    ssl_certificate_key /etc/cert/example.com.key;

    ssl_session_timeout 5m;

    ssl_protocols SSLv2 SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers on;
    index index.html index.htm index.php;
    root /home/wwwroot/www.example.com;(服务器上相应的目录)

    location ~ .*.(php|php5)?$
    {
        try_files $uri =404;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_index index.php;
        include fcgi.conf;
    }

    location /status {
        stub_status on;
        access_log off;
    }

    location ~ .*.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires 30d;
    }

    location ~ .*.(js|css)?$
    {
        expires 12h;
    }

    access_log /home/wwwlogs/access.log access;
}
```
配置结束上传以后用nginx -t 测试下配置无误 就reload一下nginx服务 检查443端口是否在监听
```bash
nginx -t
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful (显示表示配置文件没有错误)

service nginx reload (重新加载nginx服务)
netstat -lan | grep 443 (查看443端口)
tcp 0 0 0.0.0.0:443 0.0.0.0:* LISTEN (有看到这一行 就表示HTTPS已经在工作了)
```
现在使用https访问你的域名就可以了
