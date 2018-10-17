---
layout: post
title: 手动编译Nginx支持ALPN,以在最新版Chrome中支持HTTP/2
date: 2016-08-19
tags: [Nginx]
description: 手动编译Nginx支持ALPN,以在最新版Chrome中支持HTTP/2
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

###### 安装一些必要的工具
```bash
apt-get install build-essential libpcre3 libpcre3-dev zlib1g-dev
```
###### 下载需要的源代码
```bash
# Openssl版本需要1.0.2才能支持ALPN,而后者是新版Chrome支持HTTP/2的必要条件
wget -O openssl.zip -c https://github.com/openssl/openssl/archive/OpenSSL_1_1_0h.zip
unzip openssl.zip
mv openssl-OpenSSL_1_1_0h/ openssl

wget -O nginx-ct.zip -c https://github.com/grahamedgecombe/nginx-ct/archive/v1.3.2.zip
unzip nginx-ct.zip

# 获取Nginx源码
wget -c https://nginx.org/download/nginx-1.15.5.tar.gz
tar zxf nginx-1.15.5.tar.gz

# 编译
cd nginx-1.15.5/
# 编译参数参考了官方源的Nginx
./configure \
 --prefix=/etc/nginx \
 --sbin-path=/usr/sbin/nginx \
 --modules-path=/usr/lib/nginx/modules \
 --conf-path=/etc/nginx/nginx.conf \
 --error-log-path=/var/log/nginx/error.log \
 --http-log-path=/var/log/nginx/access.log \
 --pid-path=/var/run/nginx.pid \
 --lock-path=/var/run/nginx.lock \
 --http-client-body-temp-path=/var/cache/nginx/client_temp \
 --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
 --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
 --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
 --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
 --add-module=../nginx-ct-1.3.2 \
 --with-openssl=../openssl \
 --user=nginx \
 --group=nginx \
 --with-http_v2_module \
 --with-http_ssl_module \
 --with-http_gzip_static_module \
 --with-http_realip_module \
 --with-http_addition_module \
 --with-http_sub_module \
 --with-http_dav_module \
 --with-http_flv_module \
 --with-http_mp4_module \
 --with-http_gunzip_module \
 --with-http_random_index_module \
 --with-http_secure_link_module \
 --with-http_stub_status_module \
 --with-http_auth_request_module \
 --with-http_xslt_module=dynamic \
 --with-http_geoip_module=dynamic \
 --with-threads \
 --with-stream \
 --with-stream_ssl_module \
 --with-stream_geoip_module=dynamic \
 --with-http_slice_module \
 --with-mail \
 --with-mail_ssl_module \
 --with-file-aio
# 编译会花一些时间
make
make install
```
###### 错误
配置中遇到的错误:
```bash
./configure: error: the HTTP XSLT module requires the libxml2/libxslt  
libraries. You can either do not enable the module or install the libraries.
# 解决办法
apt-get install libxml2 libxslt1-dev
```
```bash
./configure: error: the GeoIP module requires the GeoIP library.  
You can either do not enable the module or install the library.  
# 解决办法
apt-get install libgeoip-dev
```

###### 启动脚本
安装好以后尝试启动:
```bash
service nginx start
Failed to start nginx.service: Unit nginx.service failed to load: No such file or directory.
```
因为`/lib/systemd/system/nginx.service`是不存在的.
手动创建该文件并赋予执行权限:

* Debian8

```bash
# vi /lib/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /var/run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```
* Debian9

```bash
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target

```
```bash
chmod +x /lib/systemd/system/nginx.service
```
现在再执行应该就可以成功启动了.

加入开机自动启动
```bash
systemctl enable nginx
```

###### 补充
* 错误
```bash
nginx: [emerg] getpwnam("nginx") failed
```
需要手动创建nginx用户.

* 错误
```bash
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (2: No such file or directory)
```
需要手动创建目录`/var/cache/nginx/`

###### 补充2
添加ngx_brotli支持
```bash
apt-get install autoconf libtool automake
git clone https://github.com/bagder/libbrotli
cd libbrotli

# 如果提示 error: C source seen but 'CC' is undefined，可以在 configure.ac 最后加上 AC_PROG_CC
./autogen.sh
./configure
make
make install
```
```bash
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli
git submodule update --init
```
