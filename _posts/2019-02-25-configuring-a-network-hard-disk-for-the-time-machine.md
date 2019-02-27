---
layout: post
title: 利用Rock64搭建内网Time Machine备份服务器
date: 2019-02-25 17:06 +0800
tags:   Apple Linux
description: 瞎折腾
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

---
很长的时间都是用一块4T装在硬盘盒里的西数硬盘来做Time Machine备份,需要备份的时候用USB将笔记本和硬盘盒连接起来,备份完毕后再将硬盘盒收起来.  
有时候会忘了备份,有时候也会觉得很麻烦.  
最重要的是这样做实在是不够优雅.  

于是想到了给笔记本配置一块网络硬盘作为Time Machine备份盘.  
苹果曾经有一个现成的商业解决方案AirPort Time Capsule, 但是这玩意儿已经停产而且价格相当不美丽.  
第一时间想到了家里现有的安装有Armbian的Rock64开发板,通过搜索了解到了专用于实现AFP协议的开源项目[Netatalk](http://netatalk.sourceforge.net)看到项目托管在sourceforge让我有不详的感觉...好在只是下载源码到本地进行编译.  

```bash
# 首先在Rock64上安装各种依赖:
apt install \
build-essential \
libevent-dev \
libssl-dev \
libgcrypt-dev \
libkrb5-dev \
libpam0g-dev \
libwrap0-dev \
libdb-dev \
libtdb-dev \
avahi-daemon \
libavahi-client-dev \
libacl1-dev \
libldap2-dev \
libcrack2-dev \
libdbus-1-dev \
libdbus-glib-1-dev \
libglib2.0-dev \
pkg-config

# 下载源码,当前最新版3.1.12
wget http://prdownloads.sourceforge.net/netatalk/netatalk-3.1.12.tar.gz
tar zxf netatalk-3.1.12.tar.gz
cd netatalk-3.1.12

# 编译安装
./configure \
    --with-init-style=debian-systemd \
    --without-libevent \
    --without-tdb \
    --with-cracklib \
    --enable-krbV-uam \
    --with-pam-confdir=/etc/pam.d \
    --with-dbus-daemon=/usr/bin/dbus-daemon \
    --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
    --with-tracker-pkgconfig-version=1.0
make -j
make install
```
安装完毕后进行一些配置,首先创建出网络硬盘所在目录:
```bash
mkdir -p /tm/data/
```
创建对应的Linux用户,并且将上一步的目录所有者设为该用户
```bash
useradd -c "Time machine" -m -s /bin/bash tm
passwd tm
chown -R tm /time\ machine/data
```
对Netatalk进行配置,配置文件所在位置`/usr/local/etc/afp.conf`添加如下内容
```config
[Time Machine]
path = /tm/data
time machine = yes
valid users = tm
spotlight = no
```
其中`path`为网络硬盘储存目录,`valid users`为上一步创建的Linux用户名.  
配置完成后重新启动对应服务
```bash
systemctl restart netatalk.service
systemctl restart avahi-daemon.service
```
到这一步就完成了网络硬盘的配置.  
然后到Mac上连接服务器就可以将网络硬盘挂载到系统上了.  
挂载的网络硬盘除了作为Time Machine备份盘外也可以当作普通硬盘使用,在通过以太网连接的时候可以达到双向1Gbps的速度.