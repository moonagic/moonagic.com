---
layout: post
title: 利用nghttpx 搭建HTTP/2代理
date: 2016-11-02
tags: [Proxy]
description: 利用nghttpx 搭建HTTP/2代理
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

利用nghttpx 搭建HTTP/2代理,配合了Squid.Squid相关配置可以参考[在Debian上搭建适用于Surge的HTTPS代理](https://moonagic.com/setup-https-proxy-on-debian/)
##### 先安装必要的依赖
```bash
apt-get install \
    g++ \
    make \
    binutils \
    autoconf \
    automake \
    autotools-dev \
    libtool \
    pkg-config \
    zlib1g-dev \
    libcunit1-dev \
    libssl-dev \
    libxml2-dev \
    libev-dev \
    libevent-dev \
    libjansson-dev \
    libjemalloc-dev \
    cython \
    python3-dev \
    python-setuptools
```
##### 源码编译nghttpx,并将文件拷贝到对应目录
```bash
git clone https://github.com/nghttp2/nghttp2.git
cd nghttp2
autoreconf -i
automake
autoconf
./configure
make
make install
echo lib > /etc/ld.so.conf.d/nghttp2.conf
ldconfig

cd contrib
cp nghttpx-init /etc/init.d/nghttpx
cp nghttpx.service /lib/systemd/system/
```
##### 创建nghttpx配置
```bash
mkdir /etc/nghttpx
cd /etc/nghttpx
vi nghttpx.conf
```
##### 配置模板
```bash
frontend=0.0.0.0,9999 # nghttpx端口
backend=127.0.0.1,3128 # 对应的squid端口
private-key-file=path/to/your/key
certificate-file=path/to/your/cert
http2-proxy=yes

workers=4
# 不添加 X-Forwarded-For 头
add-x-forwarded-for=no
# 不添加 Via 头
no-via=yes
# 不查询 OCSP
no-ocsp=yes
# NPN / ALPN 优先使用 h2
#npn-list=h2
tls-min-proto-version=TLSv1.2
tls-max-proto-version=TLSv1.2
ciphers=ECDHE+AES128
```
##### 重启nghttpx
```bash
service nghttpx start
```
