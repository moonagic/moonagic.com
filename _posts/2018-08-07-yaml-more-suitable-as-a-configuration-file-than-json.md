---
layout: post
title: YAML,比JSON更适合作配置文件
date: 2018-08-07 21:38 +0800
tags:   DEV
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

> 很多项目使用JSON作为配置文件,最明显的例子就是npm和yarn使用的package.json文件.当然这更多的是因为JSON和JS千丝万缕的关系.

但是,JSON实际上是一种**非常糟糕**的配置语言.别误会我的意思,我其实是喜欢JSON的.它是一种相对灵活的文本格式,对于机器和人类来说都很容易阅读,而且是一种非常好的数据交换和存储格式.但作为一种配置语言,它有它的不足.

### JSON的问题

##### 缺乏注释

注释对于配置语言而言绝对是一个重要的功能.注释可用于标注不同的配置选项,解释为什么要配置成特定的值,更重要的是,在使用不同的配置进行测试和调试时需要临时注释掉部分配置.当然,如果只是把JSON当作是一种数据交换格式,那么就不需要用到注释.

我们可以通过一些方法给JSON添加注释.一种常见的方法是在对象中使用特殊的键作为注释,例如“//”或“__comment”.但是,这种语法的可读性不高,并且为了在单个对象中包含多个注释,需要为每个注释使用唯一的键.David Crockford(JSON的发明者)建议使用预处理器来删除注释.如果你的应用程序需要使用JSON作为配置,那么完全没问题,不过这确实带来了一些额外的工作量.  
一些JSON库允许将注释作为输入.例如,Ruby的JSON模块和启用了JsonParser.Feature.ALLOW_COMMENTS功能的Java Jackson库可以处理JavaScript风格的注释.但是,这不是标准的方式,而且很多编辑器无法正确处理JSON文件中的注释,这让编辑它们变得更加困难.
##### 过于严格

JSON规范非常严格,这也是为什么实现JSON解析器会这么简单,但在我看来,它还会影响可读性,并且在较小程度上会影响可写性.
##### 低信噪比

与其他配置语言相比,JSON显得非常嘈杂.JSON的很多标点符号对可读性毫无帮助,况且,对象中的键几乎都是标识符,所以键的引号其实是多余的.  
此外,JSON需要使用花括号将整个文档包围起来,所以JSON是JavaScript的子集,并在流中发送多个对象时用于界定不同的对象.但是,对于配置文件来说,最外面的大括号其实没有任何用处.在配置文件中,键值对之间的逗号也是没有必要的.通常情况下,每行只有一个键值对,所以使用换行作为分隔符更有意义.  
说到逗号,JSON居然不允许在结尾出现逗号.如果你需要在每个键值对之后使用逗号,那么至少应该接受结尾的逗号,因为有了结尾的逗号,在添加新条目时会更容易,而且在进行commit diff时也更清晰.
##### 长字符串

JSON作为配置格式的另一个问题是,它不支持多行字符串.如果你想在字符串中换行,必须使用“\n”进行转义,更糟糕的是,如果你想要一个字符串在文件中另起一行显示,那就彻底没办法了.如果你的配置项里没有很长的字符串,那就不是问题.但是,如果你的配置项里包括了长字符串,例如项目描述或GPG密钥,你可能不希望只是使用“\n”来转义而不是使用真实的换行符.
##### 数字

此外,在某些情况下,JSON对数字的定义可能会有问题.JSON规范中将数字定义成使用十进制表示的任意精度有限浮点数.对于大多数应用程序来说,这没有问题.但是,如果你需要使用十六进制表示法或表示无穷大或NaN等值时,那么TOML或YAML将能够更好地处理它们.

```json
{
  "name": "rsshub",
  "version": "0.0.1",
  "description": "Make RSS Great Again!",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "docs:dev": "vuepress dev docs",
    "docs:build": "vuepress build docs",
    "format": "prettier \"**/*.{js,json,md}\" --write",
    "lint": "eslint \"**/*.js\" && prettier-check \"**/*.{js,json,md}\""
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/DIYgod/RSSHub.git"
  },
  "keywords": [
    "RSS"
  ],
  "gitHooks": {
    "pre-commit": "npm run lint"
  },
  "author": "DIYgod",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/DIYgod/RSSHub/issues"
  },
  "homepage": "https://github.com/DIYgod/RSSHub#readme",
  "devDependencies": {
    "eslint": "5.2.0",
    "eslint-config-prettier": "^2.9.0",
    "eslint-plugin-prettier": "^2.6.2",
    "lint-staged": "^7.2.0",
    "prettier": "^1.13.7",
    "prettier-check": "^2.0.0",
    "vuepress": "0.13.0",
    "yorkie": "^1.0.3"
  },
  "dependencies": {
    "art-template": "4.12.2",
    "axios": "0.18.0",
    "axios-retry": "3.1.1",
    "cheerio": "1.0.0-rc.2",
    "co-redis": "2.1.1",
    "crypto": "1.0.1",
    "form-data": "^2.3.2",
    "git-rev-sync": "1.12.0",
    "googleapis": "32.0.0",
    "iconv-lite": "0.4.23",
    "json-bigint": "0.3.0",
    "koa": "2.5.2",
    "koa-favicon": "2.0.1",
    "koa-router": "7.4.0",
    "lru-cache": "4.1.3",
    "path-to-regexp": "2.2.1",
    "readall": "1.0.0",
    "redis": "2.8.0",
    "rss-parser": "3.4.2",
    "twit": "2.2.11",
    "winston": "3.0.0"
  },
  "engines": {
    "node": ">=8.0.0"
  }
}
```
---
### YAML是什么
> YAML(YAML不是标记语言)是一种非常灵活的格式,几乎是JSON的超集,已经被用在一些著名的项目中,如Travis CI,Circle CI和AWS CloudFormation.YAML的库几乎和JSON一样无处不在.

除了**支持注释**,**换行符分隔**,**多行字符串**,**裸字符串**和**更灵活的类型系统**之外,YAML也支持**引用文件**,以避免重复代码.  
YAML的主要缺点是规范非常复杂,不同的实现之间可能存在不一致的情况.  
它将缩进视为严格语法的一部分(类似于Python,Lua等),有些人喜欢有些人不喜欢.  
这会让复制和粘贴变得很麻烦.

```yml
# html lang
language: en

# main menu navigation
menu:
  首页: /
  关于: /about
  归档: /archives
  标签: /tags

# Miscelaneous
favicon: /favicon.ico

# stylesheets loaded in the <head>
stylesheets:
- /css/style.css

# scripts loaded in the end of the body
scripts:
- /js/script.js
```
