---
layout: post
title: Yosemite黑苹果折腾笔记
date: 2014-10-19
author: 月杪
tags: [Mac]
description: Yosemite黑苹果折腾笔记
---

前天Yosemite发布正式版,于是就想着把台式机装上全新的Yosemite.

走的还是习惯的U盘安装路线,

* 1.一个8GB以上的U盘

* 2.MAS下载的原生系统安装盘

* 3.Clover的安装程式

折腾开始:

首先从原生安装程序里取出createinstallmedia(路径在/Contents/Resources/createinstallmedia),放到桌面上即可

然后将准备好的U盘重新分区,

再然后将原版的安装app写入U盘的Mac分区,在终端中输入如下命令:
```bash
sudo /Users/你的用户名/Desktop/createinstallmedia --volume /Volumes/格式化时U盘的名称 --applicationpath /Applications/Install\ OS\ X\ Yosemite.app [--force]
```
确认后就会开始将安装程序移动到U盘中.(如果是白苹果的话到这一步就已经可以开始安装了)

在移动完成后开始在U盘上安装Clover引导,

在终端输入:
```bash
mkdir /Volumes/EFI
```
然后打开Clover安装程序,在更改安装位置中选择U盘,然后选择自定义安装如图:(~~图片遗失了~~)

安装完成后在Finder中的EFI挂载盘里放入自己修改好的config.plist,以及在/CLOVER/kexts/中的10.10文件夹中放入FakeSMC(版本需要大于6.9.1315)

config.plist中重要的几点就是开启kext-dev-mode以及设定机型,其他参数未动

到现在安装U盘已经制作好了.

几个有用的命令:
```bash
diskutil list (用来查看分区列表)
mkdir /Volumes/EFI (新建EFI挂载点)
sudo mount -t msdos /dev/disk0s1 /Volumes/EFI/ (挂载EFI分区)
```
然后我们就可以从U盘引导开始安装系统了

网上教程都有说使用
```bash
Boot without caches and with extra kexts
或者
Boot with extra kexts
```
启动,但实际上我是直接启动的也没发现问题

安装会持续几分钟,并且在最后一秒停留足够长的时间,长到你以为可以直接摁restart了..

然后会提示重启,在重启进入Clover后需要再次启动安装U盘,这一次会自动继续安装.显示需要的时间大概在16分钟.

安装好后从U盘的Clover引导直接启动Yosemite.

经过各种设定后就进入系统了,但是进入后我发现我的声卡和网卡是没有驱动的

使用MultiBeast安装相应驱动后重启基本就OK了.

最后需要把Clover引导安装到Yosemite上,不然每次都需要插上U盘靠U盘上的Clover引导才能进入系统.

直接使用前面的Clover安装程序,安装位置选择Yosemite.

安装完成后将U盘Clover中的config.plist和kexts复制进相应目录

最开始我以为这样就结束了,但直接从硬盘启动却没有进入Clover.后来才发现需要在U盘Clover boot option中将对应硬盘
```bash
add Clover as UEFI boot option
```
Over,现在全都搞定了