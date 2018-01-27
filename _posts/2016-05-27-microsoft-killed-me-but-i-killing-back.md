---
layout: post
title: 微软注销了我使用多年的@msn.com邮箱
date: 2016-05-27
author: Moon
tags: [Microsoft]
description: 微软注销了我使用多年的@msn.com邮箱
---

##### 起因
> 一项服务(以下简称服务A)在多年前由于一些原因使用了一个不太常用的邮箱注册.服务A一直到现在都使用正常,而注册的邮箱因为基本不使用的原因很少登录.

##### 结果
但是在今天打算登录服务A的时候突然提示我登录前必须重置密码,而显示唯一重置密码的途径就是通过邮箱接收重置链接.

小问题而已,于是输入邮箱点击重置,提示我重置链接已经发送到邮箱.
我和以前重置各种密码一样娴熟的打开outlook.com输入账号密码登录...结果提示我That Microsoft account doesn't exist. Enter a different account or get a new one.

WTF..难道我记错了?不可能啊,才6个字母而且我在 1Password 以及iCloud Keychain 和 Chrome中记录的账号都显示我的记忆是没有出问题的..
**那么唯一的原因就是我这个邮箱真的被微软注销了!而且由于邮箱后缀为msn.com所以想要重新注册也并不是件容易的事情.**

作为一个资深马虎鬼我开始预估如果真的彻底失去这个邮箱自己将会遭受多大的损失..似乎有使用该邮箱的除了**服务A**还有很少使用的一个**Apple账号**(非国区非美区,也并没有绑定信用卡).
##### 解决
> 其实损失也不算大,但是如果重要账号使用了该邮箱注册而又不能或者很难通过其他的途径重置密码/更换注册邮箱,那么后果就非常严重了.

既然登录的时候明确提示我 doesn't exist,于是我尝试重新注册该msn.com后缀的邮箱.

直接尝试注册肯定是行不通的,我不打算去浪费这个时间.

Google到[注册@msn.com后缀邮箱的方法](http://www.benpig.com/forum/view/136)
虽然显示该网页创建于2014-01-19我还是尝试了,提示我This email is part of a reserved domain. Please enter a different email address.
估计这条路子被堵死了.

继续搜索...发现网上基本都是因为没有及时升级到outlook而被注销掉Hotmail的文章,而且我这个邮箱是有升级到outlook的.

最后搜索到[如何注册@live.com邮箱？](https://www.zhihu.com/question/26011294)里面的回答,使用Firefox+Tamper Data..按照教程一步一步操作终于将被注销的邮箱重新注册为自己另外一个msn.com邮箱的别名,最后服务A也成功的重置了密码.
#### 后记
虽然成功的把邮箱注册回来了,但是还是挺让人后怕的.微软在注销我邮箱的时候并没有通知过我(该邮箱应该绑定了手机号码,并且我设置了将邮件转发到一个常用的gmail),而从[http://answers.microsoft.com/](http://answers.microsoft.com/)中搜索到了一些跟我相同遭遇的用户,收到了如下回复:
> 可能由于您的帐户长时间未登陆(指登陆[http://outlook.com](http://outlook.com))导致帐户处于不活动状态而被自动删除，且该帐号中的所有资料也被清理和删除。
目前我们无法恢复由于帐户处于非活动状态而被自动删除的帐户及其数据，请您谅解！若有疑问，请点击参看[Microsoft服务协议](http://windows.microsoft.com/zh-cn/windows-live/microsoft-services-agreement)。

这个注册msn.com邮箱后缀的邮箱为邮箱别名的办法不可能一直有效..并且也有可能在被注销后没有被原用户发现的情况下再次被他人注册造成一些无法预计的事情发生...所以以后每个月都登录一次微软邮箱就成为很有必要的操作了.