---
layout: post
title: Setup LetsEncrypt on Debian
date: 2016-07-03
author: 月杪
tags: [SSL, Nginx]
description: Setup LetsEncrypt on Debian
---

##### Install LetsEncrypt Client
```bash
git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
```
##### Obtain a Certificate
* Inside the nginx config, add this location block:

```nginx
location ~ /\.well-known/acme-challenge {
    root /var/www/html;
}
```
* Reload Nginx:

```bash
systemctl reload nginx
```
* Generate Certificate:

```bash
cd /opt/letsencrypt
./letsencrypt-auto certonly -a webroot \
    --webroot-path=/var/www/html \
    -d example.com \
    -d www.example.com
```