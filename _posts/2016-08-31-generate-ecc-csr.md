---
layout: post
title: 生成申请 ECC 证书所需的 CSR 文件
date: 2016-08-31
author: 月杪
tags: [SSL]
description: 生成申请 ECC 证书所需的 CSR 文件
---

```bash
＃ 生成rsa证书csr
openssl genrsa -out moonagic.com.key 2048
openssl req -new -key moonagic.com.key -out moonagic.com.csr
＃ 生成ecc证书key
＃ -name 参数可以自己选择 secp521r1, prime256v1 或者是下面所用的 secp384r1
openssl ecparam -genkey -name secp384r1 -out moonagic.com-ecc.key
openssl req -new -sha384 -key moonagic.com-ecc.key -out moonagic.com-ecc.csr
```