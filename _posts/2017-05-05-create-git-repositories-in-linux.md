---
layout: post
title: 在服务器上创建自己的远程Git仓库
date: 2017-05-05
author: Moon
tags: [Git]
description: 在服务器上创建自己的远程Git仓库
---

##### 创建git用户
###### 创建git用户并设定好密码
```bash
adduser git

```
###### 限制git用户登录

修改文件`/etc/passwd`
找到对应git用户的列然后将`/bin/bash`修改为`/usr/local/bin/git-shell`

###### 添加公钥
```bash
#vi /path/to/gituser/.ssh/authorized_keys
#...添加公钥
```

##### 创建仓库
```bash
git init --bare simple.git
chown -R git:git simple.git
```
##### 使用
```bash
git clone git@serveripordomainname:/path/to/sample.git
```