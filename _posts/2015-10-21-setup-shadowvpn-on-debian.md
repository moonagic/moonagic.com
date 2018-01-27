---
layout: post
title: Debian下搭建Shadowvpn服务端
date: 2015-10-21
author: 月杪
tags: [VPN]
description: Debian下搭建Shadowvpn服务端
---


Shadowvpn衍生自libsodium,主要是为低端硬件编写的,比如一些路由器.
但是也能当做vps之间的传输工具(比如国内跳板?)
而Github上的项目更新到2.0后安装说明没有得到及时更新...前几天按照旧的说明始终不行
目前的安装流程是这样的:

##### 安装编译依赖
```bash
apt-get install build-essential automake libtool git
```

##### 从github得到源码并安装
```bash
git clone https://github.com/moonagic/ShadowVPN.git
cd ShadowVPN
git submodule update --init --recursive
./autogen.sh
./configure --enable-static --sysconfdir=/etc
make
sudo make install
```

然后就可以修改`/etc/shadowvpn`下的配置文件然后启动shadowvpn了
```bash
shadowvpn -c /etc/shadowvpn/server.conf -s start
```