---
layout: post
title:  Debian下通过自编译shadowsocks-libev搭建shadowsocks
date:   2013-11-12
tags:   Shadowsocks
author: 月杪
---

1.必要的更新
```bash
apt-get update && apt-get upgrade
```
2.安装必要组件
```bash
apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev
```
3.安装git
```bash
apt-get install git
```
4.下载shadowsocks-libev源码包并编译
```bash
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make && make install
```
5.运行shadowsocks
```bash
nohup ss-server -s IP地址 -p 端口 -k 密码 -m 加密方式 -u --fast-open &
比如：nohup ss-server -s 0.0.0.0 -p 8981 -k passwd -m chacha20 -u --fast-open &
```
6.加入开机启动
```bash
echo "nohup ss-server -s xxx -p 8981 -k xxx -m aes-256-cfb -u --fast-open &" >> /etc/rc.local
```