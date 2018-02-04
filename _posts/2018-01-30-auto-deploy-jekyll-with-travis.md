---
layout: post
title:  通过travis自动将Jekyll持续部署到服务器上
date:   2018-01-30
tags:   Jekyll
author: 月杪
---

迁移回Jekyll以后更新博客就成了比较麻烦的事情,Jekyll处于本地每次发布就需要在本地生成静态文件以后上传到服务器上.
在很久以前这一系列的工作只能手动完成,不过[travis-ci](https://travis-ci.org)给了我们提供了更方便高效的持续集成解决方案.

#### 首先
我们到[travis-ci](https://travis-ci.org)使用Github帐号登录,授权完成后进入[个人页面](https://travis-ci.org/profile)开启你需要进行持续集成的项目,就像下图中
![](https://pic.moonagic.com/images/2018/01/travis0.png)

#### 添加.travis.yml文件
在项目中新建`.travis.yml`,
```yml
language: ruby

rvm:
  - 2.3.3

before_install:

script:

after_success:

```
由于Jekyll是ruby环境下的框架所以`language`项填写的`ruby`,
`before_install`可以视为正式执行前的准备工作,
`script`则为正式执行阶段,
`after_success`为执行成功后的处理.

#### 执行
在travis启用相应项目并且在添加`.travis.yml`文件提交推送到Github后travis-ci会很快开始运行.
并且可以看到类似下图中这样的控制台执行过程,
![](https://pic.moonagic.com/images/2018/01/travis1.png)

#### 成功后的部署
执行成功后可以通过ssh以及scp将生成好的静态文件部署到服务器上.不过不管是直接在`.travis.yml`中写服务器密码还是上传私钥都相当危险.
travis-ci专门为私钥的加密准备了一套方案.
```zsh
ssh-keygen -t ecdsa -f travis_ssh_key
gem install travis
travis login
cd /path/to/repo
travis encrypt-file travis_ssh_key --add
```
执行完成后会生成一枚`travis_ssh_key.enc`,这就是加密后的私钥只需要将该文件放入代码库就行,*而上一步的`travis_ssh_key`不能放入代码库*.
同时你会发现在`.travis.yml`文件中自动添加了类似如下内容:
```zsh
before_install:
- openssl aes-256-cbc -K $encrypted_b64ef2595e9a_key -iv $encrypted_b64ef2595e9a_iv -in deploy_ecdsa.enc -out ~/.ssh/deploy_ecdsa -d
```
再将`travis_ssh_key.pub`内容上传到服务器上.
这样我们就可以在`after_success`中进行操作了,就像这样
```zsh
after_success:
- ssh -i ~/.ssh/deploy_ecdsa jekyll@107.167.176.182 "mkdir /home/jekyll/_content/"
- scp -i ~/.ssh/deploy_ecdsa -r _site/* jekyll@107.167.176.182:/home/jekyll/_content/
```
剩下的就只剩喝咖啡了.
当你看到以下提示的时候证明已经部署完毕
```zsh
Done. Your build exited with 0.
```
其实你不需要关注执行终端的信息,只需要隔一段时间检查以下Github提交页就可以了.提交页会清楚的告诉你哪些提交触发了持续部署,以及所有任务的执行状态.就像下图:
![](https://pic.moonagic.com/images/2018/01/travis2.png)
