---
layout: post
title: 一直无法新建 linode 日本,可能是设置出了问题
date: 2015-04-15
tags: [Linode]
description: 一直无法新建 linode 日本,可能是设置出了问题
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

蹲守linode一个多月,一台都没碰到,并且在这几天大家都说有货的情况下也是一样. 
昨晚在推友的帮助下确认了在他可以新建的情况下我始终无法新建日本节点. 
tk沟通后结果是因为我Hypervisor Preference设置成了KVM(不然新建其他地区的node还需要手动从Xen转到KVM) 
而东京只有Xen..但是和以前无货是一样的提示. 
最基本的缺省逻辑都没做好,也不给明确提示,也是服了. 
并且他们并没有在tk中正面回复我有关这方面应该做明确提示的建议.. 

在他们告诉我真相的时候我当时内心是崩溃的..估计肯定也有和我一样情况的人,而且他们可能还都不知道是设置出了问题