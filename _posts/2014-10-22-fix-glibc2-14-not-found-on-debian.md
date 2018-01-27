---
layout: post
title: Debian安装Ghost时提示glibc_2.14 not found的解决办法
date: 2014-10-22
author: Moon
tags: [Ghost]
description: Debian安装Ghost时提示glibc_2.14 not found的解决办法
---

在linode上安装Ghost的时候提示了glibc_2.14 not found,尝试过下载源码编译,但是比较麻烦.

后来Google到一种比较简单的办法.

添加源：
```bash
deb http://ftp.debian.org/debian sid main
```
> 注意:这是unstable源,执行结束最好将该源从列表中删除

更新源后安装包:
```bash
apt-get update
apt-get -t sid install libc6 libc6-dev libc6-dbg
```
complete!