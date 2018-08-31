---
layout: post
title: 使用LetsEncrypt签发多域名ECC证书
date: 2017-09-18
tags: [SSL]
description: 使用LetsEncrypt签发多域名ECC证书
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

#### 克隆certbot
```bash
cd /opt
git clone https://github.com/certbot/certbot.git
```
#### 配置openssl.cnf
```bash
cp /etc/ssl/openssl.cnf /opt/certbot/
vi openssl.cnf
# 在[ v3_req ]标签下添加
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = example.com
DNS.2 = www.example.com
DNS.3 = sub.example.com
...
```
#### 生成CSR文件
```bash
openssl ecparam -genkey -name secp384r1 > ec.key
openssl req -new -sha384 -key ec.key -out ec-der.csr -outform der -config openssl.cnf
```
#### 通过LetsEncrypt签发证书
```bash
./certbot-auto certonly -a webroot --webroot-path=/var/www/html -d example.com -d www.example.com ... --csr ec-der.csr
```
通过此方法生成的证书将在certbot工具目录下生成
```bash
0000_cert.pem  # crt.pem
0000_chain.pem # chain.pem
0001_chain.pem # fullchain.pem
# 上一步生成的ec.key
ec.key         # privatekey
```
#### 其他
其他步骤可参考[Setup LetsEncrypt on Debian](https://moonagic.com/setup-letsencrypt-on-debian/)