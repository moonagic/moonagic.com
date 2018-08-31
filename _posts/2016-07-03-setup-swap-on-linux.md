---
layout: post
title: 为Linux手动添加swap空间
date: 2016-07-03
tags: [Linux]
description: 为Linux手动添加swap空间
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

GCE建立的实例默认是没有swap的,所以如果需要swap的话就必须自己添加.

以下的操作都需要root权限

###### 首先先建立一个分区
```bash
dd if=/dev/zero of=/var/swap bs=1024 count=1024000
```
这样就会创建/var/swap这么一个分区文件.

###### 把这个分区变成swap分区。
```bash
mkswap /var/swap
```
###### 使用这个swap分区。使其成为有效状态。
```bash
swapon /var/swap
```
==如果需要取消的话==
```bash
swapoff /var/swap
rm /var/swap
```
现在查看一下
```bash
→ free -h
              total        used        free      shared  buff/cache   available
Mem:           592M         87M         48M        3.2M        456M        409M
Swap:          999M          0B        999M
```
显示已经有swap了,但是如果重启以后会重置,还是需要手动启动.解决方案是修改`/etc/fstab`文件,增加如下一行
```bash
/var/swap swap swap defaults 0 0
```
搞定.