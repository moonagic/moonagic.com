---
layout: post
title: Git配置非22端口访问
date: 2018-02-11 22:05 +0800
tags:   Git
author: 月杪
---

有时候我们需要通过非22端口连接git(比如你遇到了一个以为更换了ssh端口就会给服务器安全带来突飞猛进提升的CTO),同时又不想使用GitHub的时候因为更改了默认端口带来麻烦.

其实很简单,通过`.ssh`下的`config`文件就可以搞定.
很简单的通过`config`做一个映射(一般不会存在这个文件,自己新建一个就行)

```zsh
# 映射一个别名
host git.example.com
hostname git.example.com
port 2222
```
像上面这样就成功的在使用类似
```zsh
git clone git@git.example.com:xxx/xxx.git
```
命令的时候走2222端口,而当你使用类似
```zsh
git clone git@github.com:moonagic/Jekyll.git
```
命令的时候走默认的22端口.