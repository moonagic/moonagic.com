---
layout: post
title: Debian下搭建Ocserv(openconnect server),并启用证书验证
date: 2015-10-11
author: Moon
tags: [Ocserv]
description: Debian下搭建Ocserv(openconnect server),并启用证书验证
---


##### 安装编译依赖:
```bash
apt-get install build-essential autogen pkg-config
apt-get install libtalloc-dev libreadline-dev libpam0g-dev libhttp-parser-dev libpcl1-dev
apt-get install libgnutls28-dev libev-dev
apt-get install libprotobuf-c-dev libhttp-parser-dev gnutls-bin
# 0.11.8版本后如果系统也为Debian8可能需要
apt-get install -t jessie-backports libgeoip-dev
# 如果为Debian9则直接
apt-get install libgeoip-dev
```

##### ocserv编译安装(目前最新版):
```bash
wget ftp://ftp.infradead.org/pub/ocserv/ocserv-0.11.10.tar.xz
tar Jxvf ocserv-0.11.10.tar.xz
cd ocserv-0.11.10
./configure --prefix=/usr --sysconfdir=/etc
make && make install
```
在预编译前如果需要ocserv支持更多的路由表需要编辑src/vpn.h:
```c
#define DEFAULT_CONFIG_ENTRIES 200 // 默认96,iOS Anyconnect客户端最多支持到200条路由表
```
##### 配置证书:
###### CA模板，创建ca.tmpl，按需填写，这里的cn和organization可以随便填。
```bash
cn = "Your CA name"
organization = "Your fancy name"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
```
CA密钥
```bash
certtool --generate-privkey --outfile ca-key.pem
```
CA证书
```bash
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem
```
###### 同理，我们用CA签名，生成服务器证书。先创建server.tmpl模板。这里的cn项必须对应你最终提供服务的hostname或IP，否则AnyConnect客户端将无法正确导入证书。
```bash
cn = "Your hostname or IP"
organization = "Your fancy name"
expiration_days = 3650
signing_key
encryption_key
tls_www_server
```

Server密钥
```bash
certtool --generate-privkey --outfile server-key.pem
```

Server证书
```bash
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem
```

###### 将CA，Server证书与密钥复制到以下文件夹
```bash
cp ca-cert.pem /etc/ssl/certs/my-ca-cert.pem
cp server-cert.pem /etc/ssl/certs/my-server-cert.pem
cp server-key.pem /etc/ssl/private/my-server-key.pem
```

##### 生成证书认证需要的客户端证书
######创建user.tmpl
```bash
cn = "some random name"
unit = "some random unit"
expiration_days = 365
signing_key
tls_www_client
```

User密钥
```bash
certtool --generate-privkey --outfile user-key.pem
```

User证书
```bash
certtool --generate-certificate --load-privkey user-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template user.tmpl --outfile user-cert.pem
```
```bash
openssl pkcs12 -export -inkey user-key.pem -in user-cert.pem -certfile ca-cert.pem -out user.p12
```
将生成的客户端证书拷贝到可以在线下载的地址或者其他你可以导入到客户端的地方,比如我直接放到nginx的默认目录下以方便直接下载
```bash
cp user.p12 /var/www/html
```

##### ocserv配置文件
配置文件放置在`/etc/ocserv/ocserv.conf`
以下只保留重要内容
```bash
auth = "certificate"

tcp-port = 443 #端口可自定义,如果ISP对udp限制较高可尝试注释掉udp端口
udp-port = 443

# Keepalive in seconds
keepalive = 32400

# MTU discovery (DPD must be enabled)
try-mtu-discovery = true

cookie-timeout = 86400

mobile-dpd = 1800

server-cert = /etc/ssl/certs/my-server-cert.pem
server-key = /etc/ssl/private/my-server-key.pem
ca-cert = /etc/ssl/certs/my-ca-cert.pem

cert-user-oid = 2.5.4.3

dns = 8.8.8.8

```

##### 网络
```bash
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # 如果是ovz的服务器网卡应该为venet0
iptables -I INPUT -p tcp --dport 443 -j ACCEPT # 端口应与ocserv配置中配置的端口对应
iptables -I INPUT -p udp --dport 443 -j ACCEPT
```

现在直接使用
```bash
ocserv
```
就可以启用服务,需要查看日志的话可以使用
```bash
ocserv -f -d 1
```
在iOS端安装Anyconnect导入证书就可以了