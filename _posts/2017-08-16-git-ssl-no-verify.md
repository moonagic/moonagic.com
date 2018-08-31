---
layout: post
title: Git忽略证书错误
date: 2017-08-16
tags: Git
description: Git忽略证书错误
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

在尝试使用源码编译很多陈旧开源软件的时候会遇到该软件的源地址SSL证书失效(比如iftop).
~~网上流传的很多都是直接修改git全局设置:~~
```bash
git config --global http.sslVerify false
```
**但会造成更大的安全问题.**

正确方法需要在克隆的时候手动忽略证书错误:
```bash
env GIT_SSL_NO_VERIFY=true git clone https://code.blinkace.com/pdw/iftop.git
cd iftop
git config http.sslVerify "false"
```
使用env命令保证了忽略证书错误只应用于此次克隆,`http.sslVerify`保证设置只应用于该仓库.
