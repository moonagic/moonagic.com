---
layout: post
title: 在Debian上搭建适用于Surge的HTTPS代理
date: 2016-03-30
tags: [Proxy]
description: 在Debian上搭建适用于Surge的HTTPS代理
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

今天在推上偶然看到推友说到Surge等工具其实是可以支持HTTPS代理的.而HTTPS代理实际上比shadowsocks等方式更加安全,于是就尝试着自己在服务器上搭建了HTTPS代理.

## 首先确定使用的工具:
squid3 以及 stunnel4, 都可以直接使用apt包管理安装
squid其实可以通过添加编译参数来达到支持SSL的,但由于我的CPU不够强劲编译时间实在太长了,于是选择使用stunnel4来支持SSL加密.
```bash
apt-get install squid3 stunnel4
```

## 添加http认证文件
```bash
sh -c "echo -n '[帐号]:' >> /etc/squid/squid.passwd"
sh -c "openssl passwd -apr1 >> /etc/squid/squid.passwd"
// 后面会提示设定密码
```

## 修改squid默认配置
配置文件`/etc/squid3/squid.conf`
### 配置只监听本地端口
将
```bash
http_port 3128
```
改为
```bash
http_port 127.0.0.1:3128
```
### 修改访问权限与HTTP认证
在`TAG: auth_param`下方添加
```bash
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/squid.passwd
auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive off
```
在`TAG: acl`下方添加
```bash
acl ncsa_users proxy_auth REQUIRED
```
在`TAG: http_access`下方添加
```bash
http_access deny !ncsa_users
http_access allow ncsa_users
```
### 重启
```bash
service squid3 restart
```
## 配置stunnel
### 生成SSL证书
stunnel只是用来添加一层SSL加密,所以要先生成SSL证书**如果有商业SSL证书略过本步骤**
```bash
openssl genrsa -out private.pem 2048
openssl req -new -x509 -key private.pem -out public.pem -days 365 // 主机名一栏需要与ip或者域名一致
cat private.pem public.pem >> /etc/stunnel/stunnel.pem
```
### 修改配置文件
配置文件`/etc/stunnel/stunnel.conf`
```bash
client = no
[squid]
accept = 4128 #stunnel监听的端口,可以修改为任意无冲突端口
connect = 127.0.0.1:3128
cert = /etc/stunnel/stunnel.pem
# key = path/to/your/privatekey #如果是商业证书的话需要
```
修改`/etc/default/stunnel4`中的`ENABLED=1`
### 重启
```bash
service stunnel4 restart
```

## 在iOS中安装自签名证书
如果使用自签名证书的话还需要多这一步,不然iOS上是不能手动信任的.
将前面的`pulbic.pem`转为der格式
```bash
openssl x509 -outform der -in public.pem -out public.der
```
然后将`public.der`用邮件的方式发到iOS上,点击证书就会自动开始引到安装了
