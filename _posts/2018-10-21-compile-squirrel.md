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
git clone https://github.com/rime/squirrel.git
cd squirrel
git submodule update --init --recursive
make deps
sudo make install
```

后面的工作就和从pkg安装一样了.
