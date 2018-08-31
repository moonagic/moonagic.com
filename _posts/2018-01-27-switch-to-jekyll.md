---
layout: post
title:  博客从Ghost切换到Jekyll
date:   2018-01-27
tags:   Jekyll
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---


> 快4年前开始用Ghost写博客,当时觉得Ghost最大的优势就是支持Markdown格式.相比Wordpress来说不需要安装mysql和php同时和Hexo以及Jekyll相比也有强大的后台.

然而在发展了几年以后Ghost迭代到了1.0版本,
在1.0版本中出现了以下几个特点:
* 开始推荐使用mysql数据库,仍然能够指定为sqlite但是支持肯定越来越薄弱.
* 改进了编辑器,虽然在一定程度上仍然兼容Markdown但是还是给人一种不舒服的感觉.
* 开始推广自己的CL工具,不能像1.0版本以前那样直接通过npm安装和运行.并且这玩意还没做好,运行和更新非常容易报错.
* Ghost默认主题是一款杂志主题而非博客,也从侧面反应出他们的着重发展方向.marketplace中也没几个支持1.0的博客主题,并且90%为收费主题.

所以一直坚持使用0.11.12长期支持版,
然而长期支持版其实就是长期没支持慢慢就淘汰版本..

斟酌再三决定换回Jekyll.
并且很幸运还找到了和Ghost 0.11.12默认主题几乎一致的Jekyll主题[jekyll-casper](https://github.com/Jinmo/jekyll-casper).