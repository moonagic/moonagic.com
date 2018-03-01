---
layout: post
title: shadowsocks-libev在Debian下新编译安装方法
date: 2016-07-13
author: 月杪
tags: [Shadowsocks]
description: shadowsocks-libev在Debian下新编译安装方法
---

~~很久没有升级服务器上的shadowsocks-libev,结果今天发现以前的编译方法已经无法成功编译~~.[(以前的编译方法已经修正)](https://moonagic.com/setup-shadowsocks-on-debian/)
==又不行了,还是看下面吧==

###### 必要的更新
```bash
apt-get update && apt-get upgrade
```
###### 安装必要组件
```bash
# Debian8可能需要添加jessie-backports
apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libmbedtls-dev libev-dev libudns-dev libc-ares-dev
```
###### 编译安装libsodium
**如果你是使用的Debian9那么你可以安装`libsodium-dev`后跳过这一步**
```bash
git clone https://github.com/jedisct1/libsodium.git
cd libsodium
./autogen.sh
./configure
make
make install
```
###### 下载shadowsocks-libev源码包并编译
```bash
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh
./configure
make
make install
```

###### 其他
运行出现下面报错的话，运行下`ldconfig`就行。
```bash
error while loading shared libraries: libsodium.so.18: cannot open shared object file: No such file or directory
```
