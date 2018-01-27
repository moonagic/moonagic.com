---
layout: post
title: Lightsword-一个和Shadowsocks类似的工具
date: 2016-03-18
author: Moon
tags: [其他]
description: Lightsword-一个和Shadowsocks类似的工具
---

Lightsword是一个和Shadowsocks类似的代理工具,目前作者提供了[iOS][1]以及[Mac][2]客户端
而安装过程要比Shadowsocks更加简单,只是需要提前安装好nodejs.

如果你已经安装好nodejs的话只需要
```bash
npm install lightsword -g
```
就能完成安装,然后通过
```bash
lsserver --password [密码] --port [端口号] --method [加密类型] --fork --cluster
```
就可以运行起来了.只是目前加密类型可能还没有Shadowsocks那么丰富.
目前观察内存占用比我平时使用的shadowsocks-libev要高很多.
iOS上使用起来除了App Store上的版本还不支持国内分流(TestFlight上的测试版已经可以分流,目前从作者的推文来看可能还不够稳定)外感觉和Surge跑Shadowsocks没有什么区别

[1]: https://itunes.apple.com/us/app/level.4/id1082115711
[2]: https://itunes.apple.com/us/app/level.5/id1088733081