---
layout: post
title: 利用OpenSSL加解密文件
date: 2018-03-18 18:27 +0800
tags:   OpenSSL
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

openssl包括了大量的对称,非对称,摘要等加密算法,我们可以选用对称算法对文件进行加密,比如3DES,AES.
比如我们要对`ocserv-0.11.11.tar.xz`进行加密,那么我们可以使用下面的方法
```zsh
openssl des3 -salt -in ocserv-0.11.11.tar.xz -out ocserv-0.11.11.tar.xz.des3
```
其中-in是输入文件,-out是加密后输出的文件
之后会提示你输入一个用于加密的密钥,输入一个自己能记住的密码
```zsh
enter des-ede3-cbc encryption password:
Verifying - enter des-ede3-cbc encryption password:
```

然后我们可以试试加密后的文件是否可以打开
```zsh
tar Jxf ocserv-0.11.11.tar.xz.des3
tar: Unrecognized archive format
tar: Error exit delayed from previous errors.
```
嗯...可以确认文件被成功加密了.

我们试试把文件解密
```zsh
openssl des3 -d -salt -in ocserv-0.11.11.tar.xz.des3 -out newocserv-0.11.11.tar.xz
enter des-ede3-cbc decryption password:
```
解密出来的文件输出为newocserv-0.11.11.tar.xz
解压看看
```zsh
tar Jxvf newocserv-0.11.11.tar.xz
x ocserv-0.11.11/
x ocserv-0.11.11/configure
x ocserv-0.11.11/TODO
....
```
Over.
