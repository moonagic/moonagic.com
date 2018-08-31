---
layout: post
title: How to Uninstall JDK on Mac OS X
date: 2016-04-29
tags: [Mac]
description: How to Uninstall JDK on Mac OS X
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---


#### Remove the Java Runtime
```bash
sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin 
sudo rm -fr /Library/PreferencePanes/JavaControlPanel.prefpane
```

#### Removing the Java JDK
```bash
cd /Library/Java/JavaVirtualMachines
sudo rm -rf jdk*.jdk
```