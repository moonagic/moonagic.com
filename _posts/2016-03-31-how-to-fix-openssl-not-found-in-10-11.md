---
layout: post
title: 解决OS X 10.11源码编译的时候找不到openssl的问题
date: 2016-03-31
author: Moon
tags: [Mac]
description: 解决OS X 10.11源码编译的时候找不到openssl的问题
---

搭建某环境的时候需要编译一个Nginx的衍生版,由于在Linux上编译Nginx已经非常熟悉于是以为在Mac上应该也是顺手拈来..
结果make的时候直接一个大大的
```c
fatal error: 'openssl/ssl.h' file not found
```

怎么回事呢?原来苹果sdk中不再提供openssl,在
```bash
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include
```
路径下已经没有了原有的`openssl`目录..
怎么办呢?
我以前用brew升级过openssl,先找到openssl目录,我的在
```bash
/usr/local/Cellar/openssl/1.0.2g
```
先在sdk中建立`openssl`文件夹

然后将`/usr/local/Cellar/openssl/1.0.2g/include/openssl`中的头文件拷贝进去

然后编译就能通过了.