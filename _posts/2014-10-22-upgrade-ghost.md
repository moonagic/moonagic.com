---
layout: post
title: Command line only on linux servers
date: 2014-10-22
tags: [Ghost]
description: Command line only on linux servers
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

* First you’ll need to find out the URL of the latest Ghost version. It should be something like ```http://ghost.org/zip/ghost-latest.zip.```

* Fetch the zip file with ```wget http://ghost.org/zip/ghost-latest.zip``` (or whatever the URL for the latest Ghost version is).

* Delete the old ```core``` directory from your install

* Unzip the archive with ```unzip -uo ghost-latest.zip -d path-to-your-ghost-install```

* Run ```npm install --production``` to get any new dependencies

* Finally, restart Ghost so that the changes will take effect

想不到Ghost更新还是挺简单的,几分钟就把Ghost更新到了0.5.3