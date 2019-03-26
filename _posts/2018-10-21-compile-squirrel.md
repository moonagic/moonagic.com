---
layout: post
title: 自己编译鼠须管
date: 2018-10-21 21:00 +0800
tags:   rime Mac
description: 自己编译鼠须管
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

现在macOS上的第三方输入法选择的余地并不多,大众的都是天朝特色互联网流氓的产品.  
不过还好我们还有[rime系列](https://rime.im/).  
鼠须管是rime输入法在macOS下的版本,输入法设定需要用户自己编辑配置文件.  
唯一的问题是提供的二进制文件下载太旧是2015年的,而从后面基本都是稳定性提升所以能自己编译最新版本的话应该比自己直接下载的更好.  

#### 准备工作
保证机器上已安装好`Xcode Command Line Tools`,在安装了Xcode的情况下输入:
```bash
xcode-select --install
```
编译依赖,需要用到brew
```bash
brew install cmake git boost
```


#### 编译安装
```bash
git clone --recursive https://github.com/rime/squirrel.git
cd squirrel
make deps
sudo make install
```

后面的工作就和从pkg安装一样了.

#### 更新
在最近重新编译Squirrel 0.11.0 版本的时候遇到了问题.  
```bash
** BUILD FAILED **


The following build commands failed:
	Ld xbuild/lib/Release/librime.1.4.0.dylib normal x86_64
(1 failure)
make[1]: *** [release] Error 65
make: *** [librime] Error 2
```
在搜索了Squirrel的issues列表[issues#247](https://github.com/rime/librime/issues/247)后发现是因为由brew安装的最新版 boost 1.68.0 会依赖icu4c,而这个依赖在Mac下并不存在.
```bash
boost: stable 1.68.0 (bottled), HEAD
Collection of portable C++ source libraries
https://www.boost.org/
/usr/local/Cellar/boost/1.68.0 (13,712 files, 460.2MB)
  Poured from bottle on 2018-12-07 at 14:38:09
/usr/local/Cellar/boost/1.68.0_1 (13,712 files, 469.0MB) *
  Poured from bottle on 2019-01-22 at 12:44:52
From: https://github.com/Homebrew/homebrew-core/blob/master/Formula/boost.rb
==> Dependencies
Required: icu4c ✔
==> Options
--HEAD
	Install HEAD version
==> Analytics
install: 67,025 (30 days), 193,794 (90 days), 650,934 (365 days)
install_on_request: 19,138 (30 days), 55,740 (90 days), 192,830 (365 days)
build_error: 0 (30 days)
```
作者给出了几个解决方案,自己编译boost或者编译Squirrel时将librime的源码切换到`with-icu`分支.  
重新编译`--without-icu`的boost怕造成其它问题,所以我使用了后者.  
只需要在clone完成Squirrel库后到librime里手动切换分支,然后开始编译就可以正确编译通过了.  

#### 更新(2019.3.26)
针对上面的编译问题,目前文档中建议通过brew安装指定boost版本来解决.
