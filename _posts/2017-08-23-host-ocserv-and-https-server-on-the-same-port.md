---
layout: post
title: 利用Haproxy使Ocserv和HTTPS工作在同一端口
date: 2017-08-23
author: Moon
tags: [Haproxy]
description: 利用Haproxy使Ocserv和HTTPS工作在同一端口
---

```bash
#/etc/haproxy/haproxy.cfg
frontend https-in
    bind *:443
    tcp-request inspect-delay 3s
    tcp-request content accept if { req.ssl_hello_type 1 }

    acl tls req.ssl_hello_type 1
    acl has_sni req.ssl_sni -m found

    use_backend ocserv if tls { req.ssl_sni -i [ocserv domain] }
    use_backend https-out if tls { req.ssl_sni -i [domian] }

backend ocserv
    mode tcp
    option ssl-hello-chk
    server server-vpn 127.0.0.1:999 send-proxy-v2 # ocserv工作在本地999端口

backend https-out
    server server-web 127.0.0.1:4443 check #https工作在本地4443端口

```

```bash
#/etc/ocserv/ocserv.conf
listen-proxy-proto = true
```

**参考**

[HAProxy forwarding to HTTPS sites](https://community.letsencrypt.org/t/haproxy-forwarding-to-https-sites/19695/2)

[How to share the same port for VPN and HTTP](http://ocserv.gitlab.io/www/recipes-ocserv-multihost.html)