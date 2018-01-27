---
layout: post
title: Mac开发环境配置笔记
date: 2016-06-29
author: Moon
tags: [Mac]
description: Mac开发环境配置笔记
---

##### Xcode
###### 安装
直接Mac App Store搞定.
###### Command Line Tools
直接在终端输入
```bash
xcode-select --install
```
其他的会自动帮你完成 
##### Sublime
很好用的跨平台编辑器,直接安装就好.然后按照[[Package Control] https://packagecontrol.io ]中的提示配置好Package Control(Sublime上的包管理工具)
##### iTerm2+zsh
###### 安装iTerm2
先下载[iTerm2](https://www.iterm2.com),用来替代系统默认的终端.
配色可以使用[Solarized](https://github.com/altercation/solarized)
如果下面使用agnoster主题的话可能需要安装字体[PowerlineFonts](https://github.com/powerline/fonts)
###### 将zsh设为默认的shell
在终端输入
```bash
chsh -s /bin/zsh
```
然后重启iTerm2就可以了.
###### 安装和配置oh-my-zsh
在终端输入
```bash
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
```
安装好后修改配置文件`~/.zshrc`,可以直接在终端中用vi打开也可以使用Sublime打开编辑.
其他先不动,先将默认主题修改为自己熟悉的,比如agnoste.在配置文件中查找`ZSH_THEME`,然后设定为`ZSH_THEME="agnoster"`.重启iTerm2后就能看到效果了.
##### 为终端配置代理
首先安装Surge,或者其他代理工具.
配置好后在`.zshrc`中加入一行
```bash
export https_proxy=http://127.0.0.1:6152/
```
现在终端的网络请求就可以通过Surge的代理规则分流了

需要取消的话使用
```bash
unset https_proxy
```
##### Homebrew
终端输入
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
通过下列命令将/usr/local/bin添加至$PATH环境变量中
```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
```
##### CocoaPods
先更新一下gem
```bash
sudo gem update --system -n /usr/local/bin
```
如果有必要的话Ruby源可以替换为阿里的地址,如果已经在前面配置好了终端的代理可以跳过.
```bash
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem sources -l
```
然后就会列出当前的地址了
```bash
*** CURRENT SOURCES ***
https://ruby.taobao.org/
```
安装,由于系统的原因需要指定到 `/usr/local/bin` 目录
```bash
sudo gem install -n /usr/local/bin cocoapods
pod setup
```
可能会持续较长的时间
