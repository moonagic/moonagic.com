---
layout: post
title: 如何调整Mac系统通知显示时间
date: 2014-02-15
tags: [Mac, 心得]
description: 如何调整Mac系统通知显示时间
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

OSX的通知可以分为两种一种是`Alert`,一种是`banner`
区别是Alert需要用户执行动作才能消失(典型的例如更新通知)
而Banner会在桌面顶部显示数秒自动消失,本文所说的通知针对的就是Banner
操作方法:
打开终端窗口,用命令:defaults write com.apple.notificationcenterui bannerTime [time in seconds] 修改,比如把显示时间调整为25秒钟,则输入:
```bash
defaults write com.apple.notificationcenterui bannerTime 25
```
确认后需要重启系统或者注销

恢复默认设置方法:
```bash
defaults delete com.apple.notificationcenterui bannerTime
```