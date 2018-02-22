---
layout: post
title: 删除通过pkg安装的程序
date: 2018-02-22 20:24 +0800
tags:   Mac
author: 月杪
---

Mac下安装程序是非常便捷的.
但是这仅仅是局限于dmg/App安装,当你使用pkg安装了程序而开发者又没有提供卸载工具而你又需要卸载的话就完全摸不着头脑了.

不过我们可以通过`pkgutil`这个工具来搞定.

我们以mtr这个软件为例,我们并不知道mtr.pkg到底安装了什么文件,那么可以先执行`pkgutil --pkgs`
```zsh
pkgutil --pkgs
com.apple.pkg.OSX_10_13_IncompatibleAppList.16U1254
com.apple.pkg.CustomVoice_en_US_nora.16U1181
com.apple.pkg.update.os.10.13.1Supplemental.17B1003
com.apple.pkg.DevSDK_macOS1013_Public
com.apple.pkg.XProtectPlistConfigData.16U4027
com.apple.pkg.MRTConfigData.16U4028
com.apple.pkg.CLTools_Executables
com.apple.pkg.GatekeeperConfigData.16U1300
org.rudix.pkg.mtr # 这就是我们要找的pkg
com.apple.pkg.XProtectPlistConfigData.16U4024
com.apple.pkg.update.os.10.13.2SupplementalPatch.17C205
com.apple.pkg.MRTConfigData.16U4017
com.apple.pkg.MRTConfigData.16U4013
com.apple.pkg.GatekeeperConfigData.16U1259
com.apple.pkg.GatekeeperConfigData.16U1265
com.apple.pkg.CLTools_SDK_OSX1012
com.apple.update.fullbundleupdate.17D47
com.apple.pkg.DevSDK
com.apple.pkg.iTunesX.12.7.3.delta
com.apple.pkg.EmbeddedOSFirmware
com.apple.pkg.BridgeOSUpdateCustomer
com.apple.pkg.XProtectPlistConfigData.16U4022
com.apple.pkg.CLTools_SDK_macOSSDK
com.apple.pkg.iTunesX.12.7.delta
....
```
找到对应pkg的identify后执行`pkgutil --files [identify]`
```zsh
pkgutil --files org.rudix.pkg.mtr
usr
usr/local
usr/local/bin
usr/local/bin/mtr
usr/local/share
usr/local/share/doc
usr/local/share/doc/mtr
usr/local/share/doc/mtr/AUTHORS
usr/local/share/doc/mtr/COPYING
usr/local/share/doc/mtr/FORMATS
usr/local/share/doc/mtr/NEWS
usr/local/share/doc/mtr/README
usr/local/share/doc/mtr/SECURITY
usr/local/share/doc/mtr/TODO
usr/local/share/man
usr/local/share/man/man8
usr/local/share/man/man8/mtr.8
```
现在我们就知道mtr这个pkg包安装了哪些文件了.