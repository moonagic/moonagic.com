---
layout: post
title: Jekyll文章列表摘要设置
date: 2018-09-26 13:41 +0800
tags:   Jekyll
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
excerpt: 目前使用的主题并没有索引文章摘要,导致某些文章在列表中预览内容量非常大.而Jekyll自身是有提供文章摘要支持的.
---

目前使用的主题并没有索引文章摘要,导致某些文章在列表中预览内容量非常大.  
看了下Jekyll自身是有提供文章摘要支持的.  

---
#### 索引页面添加摘要显示
绝大部分情况下需要修改的内容处于index.html中.  
将摘要显示设置为`post.excerpt | strip_html`

---
#### 添加摘要
Jekyll添加摘要的方式有2种,
###### 第一种
通过分隔符的方式.  
需要先在`_config.yml`中配置分隔符
```yml
excerpt_separator:  '<!-- more -->'
```
然后就可以在正文中通过插入`<!-- more -->`来将以上的内容标记为文章摘要.

###### 第二种
直接添加post属性`excerpt`

```markdown
---
layout: post
cover: 'assets/images/cover4.jpg'
navigation: True
title: I Have a Dream
date: 1963-08-28 10:18:00
tags: speeches
subclass: 'post tag-speeches'
logo: 'assets/images/ghost.png'
author: martin
categories: martin
excerpt: I am happy to join with you today in what will go down in history as the greatest demonstration for freedom in the history of our nation.
---
```
第二种方式比第一种更直接,同时也能单独设定摘要而不是截取文章的开头部分作为摘要.
