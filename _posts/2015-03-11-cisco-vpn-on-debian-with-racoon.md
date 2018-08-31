---
layout: post
title: Debian下通过racoon搭建Cisco Ipsec VPN
date: 2015-03-11
tags: [VPN]
description: Debian下通过racoon搭建Cisco Ipsec VPN
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

```bash
apt-ge install racoon
```
安装好后编辑/etc/racoon/racoon.conf

```bash
log info;
path include "/etc/racoon";
path pre_shared_key "/etc/racoon/psk.txt";

listen {
    isakmp 9.9.9.9 [500]; #监听的端口和地址
    isakmp_natt 9.9.9.9 [4500]; #监听的端口和地址
}

remote anonymous {
    exchange_mode main,aggressive;
    doi ipsec_doi;
    nat_traversal on;
    proposal_check obey;
    generate_policy unique;
    ike_frag on;
    passive on;
    dpd_delay = 30;
    dpd_retry = 30;
    dpd_maxfail = 800;
    mode_cfg = on;
    proposal {
        encryption_algorithm aes;
        hash_algorithm sha1;
        authentication_method xauth_psk_server;
        dh_group 2;
        lifetime time 12 hour;
    }
}

timer
{
    natt_keepalive 20 sec;
}

sainfo anonymous {
    lifetime time 12 hour ;
    encryption_algorithm aes,3des,des;
    authentication_algorithm hmac_sha1,hmac_md5;
    compression_algorithm deflate;
}

mode_cfg {
    dns4 8.8.8.8,8.8.4.4;
    save_passwd on;
    network4 9.9.9.9; #VPS的IP
    netmask4 255.255.255.0;
    pool_size 250;
    banner "/etc/racoon/motd";
    auth_source system;#这里的认证方式即：useradd -s /bin/false some_username和passwd some_username)
    conf_source local;
    pfs_group 2;
    default_domain "local";
}
```
接着,配置/etc/racoon/psk.txt

在末尾加入一行
```bash
组名称         组密匙
```
即可

然后配置/etc/racoon/motd
里面是欢迎信息,可有可无

接着添加防火墙规则:
```bash
iptabls --table nat --append POSTROUTING -o ethX --jump MASQUERADE
```
不出意外的话现在就可以使用了.