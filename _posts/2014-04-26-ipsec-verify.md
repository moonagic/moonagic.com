---
layout: post
title: ipsec verify时的错误
date: 2014-04-26
tags: [ipsec]
description: ipsec verify时的错误
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

```bash
Checking your system to see if IPsec got installed and started correctly:
Version check and ipsec on-path                                                                          [OK]
Linux Openswan U2.6.37-g955aaafb-dirty/K3.13.7-x86_64-linode38 (netkey)
Checking for IPsec support in kernel                                                                    [OK]
SAref kernel support                                                                                            [N/A]
NETKEY:  Testing XFRM related proc values                                                          [OK]
            [OK]
            [OK]
Checking that pluto is running                                                                             [OK]
Pluto listening for IKE on udp 500                                                                        [OK]
Pluto listening for NAT-T on udp 4500                                                                 [OK]
Two or more interfaces found, checking IP forwarding                                         [OK]
Checking NAT and MASQUERADEing                                                                   [OK]
Checking for 'ip' command                                                                                  [OK]
Checking /bin/sh is not /bin/dash                                                                        [WARNING]
Checking for 'iptables' command                                                                         [OK]
Opportunistic Encryption Support                                                                        [DISABLED]
```
debian 已经使用dash来代替bash,执行以下命令可将默认脚本执行器改回bash
```bash
dpkg-reconfigure dash
```
提示选择no