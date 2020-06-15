---
layout: post
title: 添加对WebP格式图片的支持
date: 2018-11-08 15:25 +0800
tags:   Blog
description: AirPods 对比 Jabra Elite Active 65t
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

> WebP格式是从Google vp8 视频编码衍生出的一种web image编码格式.同时支持有损和无损压缩,其中有损压缩在保持非常高质量图像的前提下也能获得非常不错的文件压缩效率.  
> [WebP的维基百科](https://en.wikipedia.org/wiki/WebP)

前几天看到firefox也开始着手对WebP格式的支持了[繼Chrome、Opera及Edge之後，Firefox也將支援WebP圖檔格式了](https://www.ithome.com.tw/news/126842).  
所以目前现代主流浏览器还没有计划正式支持WebP的就只剩苹果一家的Safari了.  
于是我想自己的博客所用到的图片资源也转换为WebP格式.  

#### 准备工作
要获得对应的WebP文件,最简单的方式就是博客自动部署的时候在部署脚本里添加自动转换功能.  
先在服务器上安装自动转换工具,很幸运的是我所使用的Linux发行版官方源里就有对应的工具.
```bash
apt install webp
```
安装好以后就可以使用`cwebp``dwebp`命令进行WebP文件的编解码了.  
比如将png图片转换为WebP
```bash
cwebp input.png -o output.webp
# 设定质量,在未设定的时候默认为75
cwebp -q 90 input.png -o output.webp
```
然后在自动部署脚本中将所有的图片都转换为WebP,这一部分的参考
```bash
#!/bin/zsh
imageDir="path/to/images"
function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            cwebp $1"/"$file -o $1"/"$file".webp" &
        fi
    done
}
read_dir $imageDir
```

#### 修改的内容
现在准备工作做好了,但是还有一点工作需要处理:  
> 在支持的浏览器上正确展示WebP图像,同时在不支持的浏览器上也可以正确的展示png/jpg等常规图像格式.

办法有很多种,这里我们直接通过HTML代码来解决
```html
<picture class="picture">
  <source type="image/webp" srcset="path/to/webp">
  <img class="image" src="path/to/png or jpg">
</picture>
```

现在就可以正确的在Chrome上展示WebP图片而在Safari上展示jpg图片了.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/11/2018-11-08at155024.webp">
  <img class="image" src="/images/2018/11/2018-11-08at155024.png">
</picture>
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/11/2018-11-08at155123.webp">
  <img class="image" src="/images/2018/11/2018-11-08at155123.png">
</picture>
而同时,在成功展示WebP格式图像的时候也很大程度节省了流量
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/11/2018-11-08at155608.webp">
  <img class="image" src="/images/2018/11/2018-11-08at155608.png">
</picture>

<span style="color: green">Enjoy.</span>
