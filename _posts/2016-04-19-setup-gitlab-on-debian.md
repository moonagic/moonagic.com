---
layout: post
title: 在Debian上搭建Gitlab,并禁用内嵌Nginx
date: 2016-04-19
tags: [Gitlab]
description: 在Debian上搭建Gitlab,并禁用内嵌Nginx
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

最近需要为公司搭建git代码仓库,结束后决定将过程记录.

#### 首先获取gitlab安装包
打开
```bash
https://about.gitlab.com/downloads/
```
选择自己的系统,按照提示安装.当执行完
```bash
gitlab-ctl reconfigure
```
后其实已经可以在浏览器中打开了,但是默认的是运行在gitlab内嵌的Nginx中,对于强迫症来说还是挺难受的.(其实内嵌的Nginx是不会影响到独立安装的Nginx的)

于是决定使用独立安装的Nginx代替内嵌的来运行gitlab.

#### 先禁用内嵌的Nginx
编辑`/etc/gitlab/gitlab.rb`在Nginx部分添加一行
```bash
nginx['enable'] = false
```

然后再执行
```bash
gitlab-ctl reconfigure # 每当修改了gitlab的配置文件都需要执行
```
现在已经禁用掉内嵌的Nginx了.
#### 配置独立安装的Nginx
在Nginx配置目录中新建一个配置文件`git.conf`
```bash
# gitlab socket 文件地址
upstream gitlab {
  server unix://var/opt/gitlab/gitlab-rails/sockets/gitlab.socket;
}

server {
    listen 80;
    server_name git.example.com;
    return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  server_name git.example.com;

  ssl on;
  ssl_certificate path/to/ssl_certificate; #需要替换自己的证书
  ssl_certificate_key path/to/ssl_certificate_key; #需要替换自己的证书

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_stapling on;
  ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA";
  ssl_prefer_server_ciphers on;
  
  ssl_session_cache shared:SSL:50m;
  
  ssl_session_timeout 10m;

  ssl_dhparam path/to/dhparam.pem; #需要替换自己的路径
  
  add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
    ssl_stapling_verify on;
  

  server_tokens off;     # don't show the version number, a security best practice
  root /opt/gitlab/embedded/service/gitlab-rails/public;

  # Increase this if you want to upload large attachments
  # Or if you want to accept large git objects over http
  client_max_body_size 250m;

  # individual nginx logs for this gitlab vhost
  #access_log  /var/log/gitlab/nginx/gitlab_access.log;
  #error_log   /var/log/gitlab/nginx/gitlab_error.log;

  location / {
    # serve static files from defined root folder;.
    # @gitlab is a named location for the upstream fallback, see below
    try_files $uri $uri/index.html $uri.html @gitlab;
  }

  # if a file, which is not found in the root folder is requested,
  # then the proxy pass the request to the upsteam (gitlab unicorn)
  location @gitlab {
    # If you use https make sure you disable gzip compression 
    # to be safe against BREACH attack

    proxy_read_timeout 300; # Some requests take more than 30 seconds.
    proxy_connect_timeout 300; # Some requests take more than 30 seconds.
    proxy_redirect     off;

    proxy_set_header   X-Forwarded-Proto $scheme;
    proxy_set_header   Host              $http_host;
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header   X-Frame-Options   SAMEORIGIN;

    proxy_pass http://gitlab;
  }

  # Enable gzip compression as per rails guide: http://guides.rubyonrails.org/asset_pipeline.html#gzip-compression
  # WARNING: If you are using relative urls do remove the block below
  # See config/application.rb under "Relative url support" for the list of
  # other files that need to be changed for relative url support
  location ~ ^/(assets)/  {
    root /opt/gitlab/embedded/service/gitlab-rails/public;
    # gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  error_page 502 /502.html;
}
```
然后刷新Nginx配置文件
```bash
service nginx reload
```
现在直接从浏览器打开,一个大大的502冒出来..结果发现是用户组问题,解决办法:
```bash
chmod -R o+x /var/opt/gitlab/gitlab-rails
```
现在应该一切都正常了.

#### 补充:
安装好以后又需要将git仓库移动到外置硬盘,查看[官方文档](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/configuration.md)后发现只需要修改`/etc/gitlab/gitlab.rb`中的
```bash
git_data_dir "path/to/own/repositories"
```
然后重新配置
```bash
gitlab-ctl reconfigure
```
就可以了.
而如果在当前仓库已经有内容的情况下还需要执行如下操作
```bash
# Prevent users from writing to the repositories while you move them.
sudo gitlab-ctl stop

# Note there is _no_ slash behind 'repositories', but there _is_ a
# slash behind 'git-data'.
sudo rsync -av /var/opt/gitlab/git-data/repositories /mnt/nas/git-data/

# Fix permissions if necessary
sudo gitlab-ctl reconfigure

# Double-check directory layout in /mnt/nas/git-data. Expected output:
# gitlab-satellites  repositories
sudo ls /mnt/nas/git-data/

# Done! Start GitLab and verify that you can browse through the repositories in
# the web interface.
sudo gitlab-ctl start
```