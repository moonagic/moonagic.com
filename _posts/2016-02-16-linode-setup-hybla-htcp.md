---
layout: post
title: Linode编译hybla htcp模块
date: 2016-02-16
tags: [VPS]
description: Linode编译hybla htcp模块
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

#### 查看vps内核版本：
```bash
uname -a
Linux magic 4.4.0-x86_64-linode63 #2 SMP Tue Jan 19 12:43:53 EST 2016 x86_64 GNU/Linux
```

#### 下载相同版本的内核源码
可以去 https://www.kernel.org/pub/linux/kernel/ 下载对应版本的内核源码
```bash
mkdir kernel
cd kernel
wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.tar.gz 
tar xzvf linux-4.4.tar.gz
```

#### 安装内核编译工具
```bash
apt-get install build-essential libncurses5-dev module-init-tools
```

#### 配置内核编译文件
```bash
cd linux-4.4
zcat /proc/config.gz > .config
```
编辑.config文件,查找 CONFIG\_TCP\_CONG\_CUBIC=y,增加 CONFIG\_TCP\_CONG\_HYBLA=y, CONFIG\_TCP\_CONG\_HTCP=y

然后编译
```bash
make
```
等待编译完成,一般20分钟左右

#### 准备编译模块
```bash
cd net/ipv4/
mv Makefile Makefile.old
vi Makefile
```
以hybla为例
```bash
# Makefile for tcp_hybla.ko
obj-m := tcp_hybla.o
KDIR := /root/kernel/linux-3.11.6
PWD := $(shell pwd)
default:
$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules #以tab开头
```

#### 开始编译模块
```bash
cd /root/kernel/linux-4.4
make modules
```

#### 加载模块
```bash
cd /root/kernel/linux-4.4/net/ipv4
insmod ./tcp_hybla.ko
```
如果遇到command not found: insmod则需要手动安装
```bash
apt-get install module-init-tools
```

#### BTW
编译的时候如果出现如下错误
```bash
scripts/extract-cert.c:21:25: fatal error: openssl/bio.h: No such file or directory
```
需要源安装`libssl-dev`就可以了