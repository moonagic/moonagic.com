---
layout: post
title: 解决Chrome系统菜单字体无法禁用DirectWrite的问题
date: 2015-09-06
tags: [Chrome]
description: 解决Chrome系统菜单字体无法禁用DirectWrite的问题
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

Chrome从37开始支持DirectWrite,但是在低分屏下显示效果反而更差,并且与mactype冲突.
当时的解决办法为在flags中禁用DirectWrite,也确实解决了问题,但是似乎从Chrome42以后这个方法不再适用于Chrome的系统菜单部分.
在忍受了很久之后终于得知解决办法,添加Chrome启动参数
```bash
--disable-directwrite-for-ui
```
