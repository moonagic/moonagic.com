---
layout: post
title: 从源码编译安装GIt
date: 2017-05-05
tags: [Git]
description: 从源码编译安装GIt
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

##### 编译依赖
```bash
apt-get install libcurl4-gnutls-dev libexpat1-dev gettext zlib1g-dev libssl-dev
```
##### 下载
到[Github](https://github.com/git/git/releases)下载需要的版本
##### 安装
```bash
autoconf
./configure prefix=/usr/local all
make
make install
```
