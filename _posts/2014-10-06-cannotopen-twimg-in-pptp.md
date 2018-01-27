---
layout: post
title: 解决pptp下无法打开twimg.com等链接
date: 2014-10-06
author: 月杪
tags: [pptp]
description: 解决pptp下无法打开twimg.com等链接
---

前几天把OAH上专用做代理的vps从centos换成了自己更熟悉的debian,结果直接搭的pptp速度不错但是twimg这样的连接打开会超时.

在尝试了更换DNS重启vps等一系列方式后还是无法解决,后来Google到应该是因为pptpd中预设MTU值的问题导致了某些链接打开超时.解决办法直接假如iptables规则
```bash
# 192.168.0.0 应为config中对应的ip段
iptables -A FORWARD -p tcp --syn -s 192.168.0.0/24 -j TCPMSS --set-mss 1356
```
问题解决