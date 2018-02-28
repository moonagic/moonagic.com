---
layout: post
title: 使用CURL请求HTTPS页面时指定IP
date: 2018-02-28 13:08 +0800
tags:   CURL, HTTPS
author: 月杪
---

一般在使用CURL请求自定义IP地址并且指定HOST的话可以这样
```zsh
curl http://127.0.0.1/ -H 'Host: moonagic.com'
```
但是如果你需要请求的地址是HTTPS的就不行了,
```zsh
curl [IP]:443 -H 'Host:moonagic.com'
curl: (52) Empty reply from server
curl https://[IP]:443 -H 'Host:moonagic.com'
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option.
HTTPS-proxy has similar options --proxy-cacert and --proxy-insecure.
```
因为IP绝大多数情况下无法通过域名证书验证,还好CURL中有`--resolve`参数可以让我们方便的指定域名的解析
```zsh
# --resolve参数形式
--resolve host:port:address
# 示例
curl --resolve moonagic.com:443:127.0.0.1 https://moonagic.com
```