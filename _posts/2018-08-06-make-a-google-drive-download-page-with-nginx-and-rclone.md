---
layout: post
title: 用Nginx和rclone做Google Drive下载页
date: 2018-08-06 19:33 +0800
tags:   Linux
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
excerpt: 简述将服务器上挂载的Google Drive作为下载页的配置过程
---

> 在写了[在Linux上使用rclone挂载Google Drive等服务](https://moonagic.com/mount-google-drive-with-rclone/)以后偶然想到能挂载Google Drive等一众网盘以后还能催生出很多玩法,其中一种就是与Nginx等Web server结合起来,做一个方便的下载页面.

#### 准备
要实现下载页主要用到Nginx以及Nginx提供的一些功能.  
其中包括自动检索,身份验证等.

#### 配置
默认的情况下Nginx索引到目录会直接返回403,这个时候需要的只是开启`autoindex`
```bash
autoindex on;
```
重载后就可以成功开启autoindex模式了
![](https://cdn.agic.io/images/2018/08/Screen Shot 2018-08-06 at 21.21.28.png)

成功开启后还需要配置身份验证,不然只要知道地址谁可以随意下载网盘中的文件了.  
Nginx给我们提供了很简单的方式`basic auth`,配置方法:
```bash
printf "user:$(openssl passwd -crypt passwd)\n" >> /etc/nginx/conf.d/passwd
```
其中`user`代表你的帐号,`passwd`代表你的密码,`/etc/nginx/conf.d/passwd`是生成好的验证文件.  
然后在Nginx的配置文件相应位置加入
```bash
auth_basic "Authorized"; # 必须有basic验证的描述,否则并不会弹出要求验证窗口
auth_basic_user_file /etc/nginx/conf.d/passwd;
```
重载后再次打开页面,就会看到提醒验证的弹窗了.  
![](https://cdn.agic.io/images/2018/08/Screen Shot 2018-08-06 at 20.27.20.png)

#### 美化
经过上面的配置已经基本可用了,不过默认的index界面确实不太美观.  
于是找到了`Nginx-Fancyindex-Theme`这个美化模板,配置好以后的样子大概是这样:
![](https://cdn.agic.io/images/2018/08/Screen Shot 2018-08-06 at 20.27.34.png)
稍微好看了一丢丢.

#### 下载
在页面可以直接得到下载链接,不过脱离了浏览器直接下载的话会出现验证失败的错误信息,比如:
```bash
curl https://drive.moonagic.com/moonagic.com_ecc.zip -o moonagic.com_ecc.zip
<html>
<head><title>401 Authorization Required</title></head>
<body bgcolor="white">
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.15.2</center>
</body>
</html>
```
```bash
wget https://drive.moonagic.com/moonagic.com_ecc.zip
--2018-08-06 21:33:48--  https://drive.moonagic.com/moonagic.com_ecc.zip
Resolving drive.moonagic.com (drive.moonagic.com)... 104.199.220.164
Connecting to drive.moonagic.com (drive.moonagic.com)|104.199.220.164|:443... connected.
HTTP request sent, awaiting response... 401 Unauthorized

Username/Password Authentication Failed.
```
这个时候需要手动添加basic验证信息,
```bash
curl https://user:password@drive.moonagic.com/moonagic.com_ecc.zip -o moonagic.com_ecc.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 1682k  100 1682k    0     0   862k      0  0:00:01  0:00:01 --:--:--  862k
```
```bash
wget --http-user=user --http-password=password https://drive.moonagic.com/moonagic.com_ecc.zip
--2018-08-06 21:37:41--  https://drive.moonagic.com/moonagic.com_ecc.zip
Resolving drive.moonagic.com (drive.moonagic.com)... 104.199.220.164
Connecting to drive.moonagic.com (drive.moonagic.com)|104.199.220.164|:443... connected.
HTTP request sent, awaiting response... 401 Unauthorized
Authentication selected: Basic realm="Authorized"
Reusing existing connection to drive.moonagic.com:443.
HTTP request sent, awaiting response... 200 OK
Length: 1722401 (1.6M) [application/zip]
Saving to: ‘moonagic.com_ecc.zip’

moonagic.com_ecc.zip.1   100%[==================================>]   1.64M  --.-KB/s    in 0.02s

2018-08-06 21:37:44 (79.3 MB/s) - ‘moonagic.com_ecc.zip’ saved [1722401/1722401]
```

#### 其他
由于是通过rclone挂载的Google Drive,所以下载大一点的文件的时候会察觉到比较明显的准备时间,不过并没有什么大碍.  
其实rclone挂载网盘后能做的还有很多,比如写一个简单的shell脚本就能实现Linux各种配置的每周/每日/每小时备份等等.
