---
layout: post
title:  利用iodine为Ocserv提供本地DNS服务
date:   2017-10-13
tags:   Ocserv SSL
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---


#### 起因
尝试在同一台Linux上同时安装Ocserv和Dnsmasq,并将Ocserv的DNS配置指向Dnsmasq,然而不管是走内网IP还是外网IP都完全不工作.发邮件询问Ocserv作者本人收到的回复也是建议我检查Dnsmasq的配置.~~鬼都知道Dnsmasq配置不可能有问题啦!~~

后来猜测是虚拟网卡的原因,于是尝试自己建立内网DNS隧道来搞定它.

#### 安装及配置
```bash
# 安装
apt-get install iodine
# 启动
nohup iodined -f 10.10.10.10 gov.com &
```
启动后通过`ifconfig`能查看到已经生成了名为`dnsx`的虚拟网卡,地址为`10.10.10.10`.
```bash
dns0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1130
        inet 10.10.10.10  netmask 255.255.255.224  destination 10.10.10.10
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
#### 配置Dnsmasq
配置好DNS隧道以后就可以将Dnsmasq的监听地址修改为相应的地址
```bash
# vi /etc/dnsmasq.conf

....
listen-address=127.0.0.1,10.10.10.10
....
```
_**切记先建立DNS隧道再restart/reload Dnsmasq**_

#### 配置Ocserv
现在编辑`ocserv.conf`将dns设定为相应地址然后重启Ocserv即可.

#### 其他
* Ocserv需要将对应IP走代理
* 如果所处的Wifi环境IP段和DNS隧道相同的话23333
