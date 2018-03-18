---
layout: post
title: 使用certbot工具签发泛域名证书
date: 2018-03-14 10:45 +0800
tags:   SSL
author: 月杪
---

Letsencrypt的泛域名证书计划2月27日正式发布,结果临近的时候突然宣布延期了.本以为会像ECC中间证书延期一样等不到了,结果今天一大早就看到了正式发布的消息.
看到了[acme.sh已经正式支持泛域名证书签发](https://www.v2ex.com/t/437798)的消息,结果acme.sh支持的dns验证暂时并不支持我所使用的Google Cloud DNS.
于是尝试使用certbot(这也是一直以来我使用的签发工具).

其实和签发单域名的方法差不多,只是需要多一个`--server`参数
```zsh
./certbot-auto \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --manual \
    --preferred-challenges dns-01 certonly
```
接着会让你填入需要签发的域名,直接输入类似`*.example.com`就好.
后面的dns认证就和单域名一样了.

当然上一步你可以选择传入csr文件:
```zsh
./certbot-auto \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --manual \
    --preferred-challenges dns-01 certonly \
    --csr domain.csr
```
这样可以同时签发出多域名和ECC证书.
