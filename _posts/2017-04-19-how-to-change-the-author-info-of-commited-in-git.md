---
layout: post
title: 修改Git已提交的Email和Name
date: 2017-04-19
tags: [Git]
description: 修改Git已提交的Email和Name
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

由于在Windows上使用Git的千奇百怪解决方案造成中途需要从babun更换到cygwin..结果更换的时候将Git配置中的Email输入错误,于是寻找了一下修改多个commit中的信息.
最后在[changing-author-info](https://help.github.com/articles/changing-author-info/)中看到了解决方案.
保存脚本
```bash
#!/bin/sh

git filter-branch --env-filter '
OLD_EMAIL="your-old-email@example.com"
CORRECT_NAME="Your Correct Name"
CORRECT_EMAIL="your-correct-email@example.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```
修改对应的`OLD_EMAIL`,`CORRECT_NAME`,`CORRECT_EMAIL`

然后运行即可.
