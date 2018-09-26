---
layout: post
title: 组建一个简易的自用CDN
date: 2018-09-25 14:23 +0800
tags:   CDN Nginx
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
excerpt: 利用现有的服务和资源组建一个自用的简易CDN
---

---
#### CDN是什么
> A content delivery network or content distribution network (CDN) is a geographically distributed network of proxy servers and their data centers. The goal is to distribute service spatially relative to end-users to provide high availability and high performance. CDNs serve a large portion of the Internet content today, including web objects (text, graphics and scripts), downloadable objects (media files, software, documents), applications (e-commerce, portals), live streaming media, on-demand streaming media, and social media sites.

[CDN 维基百科](https://en.wikipedia.org/wiki/Content_delivery_network)

---
#### 我对CDN的简单需求
现在博客是放在美西的服务器,访问延迟还能接受.  
不过如果文章中有大量图片的话还是会有明显的感觉,所以打算利用CDN加速一些主要的静态文件.  

---
#### 选择CDN
国内的话CDN可选的太少了,而且几乎可以肯定没有服务商能完全达到要求,  
* 支持HTTPS
* 支持HTTP/2
* 支持TLS1.3
* 支持自定义域名

所以参考当前对CDN的简单需求决定自己组一个简易的CDN

---
#### 如何自己组一个简易CDN
首先我们需要达到可以让不同区域访问同一个域名的时候指向不同服务器的目的,达到这两个目的至少有2个办法:
* Anycast
* DNS分区解析

Anycast的话目前在国内因为政策原因几乎无法落地,所以对我们来说DNS分区解析是唯一的办法.  
很幸运目前[NS1](http://ns1.com)提供免费的DNS分区解析.  
NS1甚至在美国还能实现分州解析,不过对于中国大陆来说并不能区分省级,当然对我来说完全够用了.  

实现了DNS分区解析后面的事情就简单多了,现在我们只需要按照DNS分区解析的区域部署对应的服务器.  
然后我们需要实现服务器之间的关联,实现这个关联最简单也最直接的办法就是利用Nginx的反向代理功能.  
![](https://cdn.agic.io/images/2018/09/cdn.png)
在打通网络以后通过Nginx自带的proxy_cache模块配置好各级缓存规则,现在一个简易的CDN就组建完成了.

---
#### 后记
整个组建简易CDN的过程没有实际创造任何东西,只是对现有的资源/服务进行整合就达到了最初的需求.  
虽说并不是一个完整的可商用的CDN的解决方案,不过自己拿来用用足够了.  
<font color=#00ff00>Enjoy.</font>

