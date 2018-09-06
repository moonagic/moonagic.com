---
layout: post
title: Mac安装mtr
date: 2015-11-21
tags: [Mac]
description: Mac安装mtr
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

在Linux上诊断路由最好用的莫过于mtr了,而到了OS X上却没有提供内置(Linux也没内置,但是只需要一个简单的命令就能安装了).于是需要我们自己来安装.

其实Mac上安装mtr也很简单,不过需要用到brew,如果你没有安装brew的话需要先安装一下:

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
然后通过brew来直接安装

```bash
brew install mtr
```
安装结束后尝试使用的话会提示你`command not found`...
解决办法是在你的shell配置中通过alias将路径映射到mtr命令上

如果你的shell是zsh的话直接打开.zshrc加入一行
```bash
alias mtr=/usr/local/sbin/mtr
```
`/usr/local/sbin/mtr`是mtr的安装路径,可能不同的机器路径不同,比如我的rMBP和iMac的安装路径就只有rMBP是这个路径.不过安装的时候会告诉你相关路径的.

现在再执行mtr结果提示`unable to get raw sockets`
这时候需要添加权限
```bash
sudo chown root mtr
sudo chmod u+s mtr
```
然后就可以在Mac上愉快的使用mtr了.

##### ~~更新(已过期)~~
目前通过brew安装的mtr使用有很大的问题,需要自己cd到指定目录才可以正常使用.
通过pkg安装mtr会好很多,pkg地址在[mtr pkg](http://rudix.org/packages/mtr.html).

##### 2018-02-22 更新
上一次更新使用pkg安装虽然能使用,但是版本太老而且是纯黑的背景如果你控制台并不是纯黑的话会非常难受.
我卸载了使用pkg安装的mtr,还是选择使用brew源安装.
和以前不同的是我的安装路径到了`/usr/local/Cellar/mtr/0.92/sbin`.
我将该目录下的`mtr`以及`mtr-packet`拷贝到`/usr/local/bin`目录下,然后将这两个文件都添加权限就又可以正常使用了.

##### 2018-07-14 更新
最新版不支持上面的操作了,老老实实加sudo吧.
