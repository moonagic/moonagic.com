---
layout: post
title: L2TP搭建日志
date: 2014-04-29
author: Moon
tags: [l2tp]
description: L2TP搭建日志
---

重装了下linode,结果发现居然没有debian6了...

于是选了7.4

在搭L2TP的时候发现了问题,win和android都可以正常连接,但iPhone, OS X就是连不上

由于从6换到7,下意识以为是debian的问题

折腾了好久才发现是apt自带的openswan的bug

后来手动将openswan版本从apt自带的最新版1:2.6.37-3+deb7u1换到了1:2.6.37-3
```bash
apt-get install openswan=1:2.6.37-3
```
问题解除