---
layout: post
title: 编译自己的iOS版Telegram
date: 2019-06-03 16:32 +0800
tags:   Telegram
description: 瞎折腾
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

---
[Telegram](https://en.wikipedia.org/wiki/Telegram_(software)) 是一款近两年非常火的多平台客户端开源聊天软件.  
既然客户端是开源的那么我打算自己编译一下来看看.  
网上已经有了一些编译Telegram的信息,但这些信息可能因为代码更新基本都不可用了.  

#### 拉取代码
```Git
git clone https://github.com/peter-iakovlev/Telegram-iOS.git
cd Telegram-iOS/
# Telegram-iOS 很大部分的功能都是通过submodule来提供的,所以还需要拉取submodule
git submodule update --init --recursive
```
拉取完成以后用Xcode打开项目,结果发现很多submodule是丢失的.  
结果打开submodule文件发现居然很多module的url都指向一个相对路径...
```bash
[submodule "submodules/AsyncDisplayKit"]
	path = submodules/AsyncDisplayKit
url=../AsyncDisplayKit.git
[submodule "submodules/Display"]
	path = submodules/Display
url=../Display.git
[submodule "submodules/HockeySDK-iOS"]
	path = submodules/HockeySDK-iOS
url=../HockeySDK-iOS.git
[submodule "submodules/libtgvoip"]
	path = submodules/libtgvoip
url=https://github.com/grishka/libtgvoip.git
[submodule "submodules/lottie-ios"]
	path = submodules/lottie-ios
url=../lottie-ios.git
[submodule "submodules/MtProtoKit"]
	path = submodules/MtProtoKit
url=../MtProtoKit.git
[submodule "submodules/Postbox"]
	path = submodules/Postbox
url=../Postbox.git
[submodule "submodules/SSignalKit"]
	path = submodules/SSignalKit
url=../Signals.git
[submodule "submodules/TelegramCore"]
	path = submodules/TelegramCore
url=../TelegramCore.git
[submodule "submodules/TelegramUI"]
	path = submodules/TelegramUI
url=../TelegramUI.git
[submodule "submodules/ffmpeg"]
	path = submodules/ffmpeg
url=../ffmpeg.git
[submodule "submodules/LegacyComponents"]
	path = submodules/LegacyComponents
url=../legacycomponents.git
[submodule "submodules/webp"]
	path = submodules/webp
url=../webp.git
```
万幸,所有指向相对路径的module其实都在 https://github.com/peter-iakovlev 这个账户下.  
于是手动将所有相对路径的url都做相应修改后重新拉取submodule就可以正常拉取到所有需要用到的submodule了.  

#### 编译和必要的修改
现在已经可以正常使用Xcode打开项目了,当然目前还有太多的错误需要解决.  
首先将Bundle ID修改为我自己需要的ID.  
然后就是开发者账户的配置,将所有targets都配置为自己的开发者账户.  
配置后仍然有大量的错误,主要是Capabilities.  
打开Capabilities后发现主要问题是App groups ID需要配置为自己开发者账户下的ID,另外Telegram项目本身开启了Apple Pay所以需要配置Merchant ID.
配置好以后所有的错误应该都消失了,意气风发的开始了编译...  
结果提示错误:`Yasm not found`  

好吧,通过搜索发现这是一个小问题,直接通过brew安装这个包就好.
```bash
brew install yasm
```
再次开始编译,这次遇到的问题是`Use of undeclared identifier 'APP_CONFIG_DATA'`,在项目issues列表中找到了相应的解决方案:  
找到对应的一次[commit](https://github.com/peter-iakovlev/Telegram-iOS/commit/f5880c1a3c63a77179f1c4790716da0bc7e3a6c0), 将`Telegram-iOS/BuildConfig.m`新增的内容注释后,将对应的3个数值替换为自己在 https://my.telegram.org/auth 申请到的AppID等数据.  
_在最新的5.7版本源码中已经只需要修改以下3项而不需要注释任何代码了_
```c
- (NSData * _Nullable)bundleData {
    return nil;//_bundleData;
}

- (int32_t)apiId {
    return 123456;//_apiId;
}

- (NSString * _Nonnull)apiHash {
    return @"aaabbbcccdddeeefff";//_apiHash;
}
```
替换后再次编译,应该就可以通过了.  

#### 一些注意的地方
* `Telegram-iOS/Config-Fork.xcconfig`是我们需要编译的target, 我同时也将 Bundle ID 和 AppID等信息填写到了这个文件中.  
* 需要注意 Notification 等 Extension 的 BundleID 和 Telegram 的 BundleID 关系.


#### APNS
本来以为APNS是没什么希望的,结果在Telegram的控制台居然看到了上传APNS证书的功能,在正确上传证书后APNS也可以正常工作了.  
只是需要注意后台只接受上传pem格式证书.


#### 取消群组和频道封禁
编辑`TelegramCore/Network/Api1.swift`的`parse_channel`函数,在`if Int(_1!) & Int(1 << 17) != 0 {_13 = reader.readInt32() }`后添加内容:  
```swift
_1 = _1! & ~(1 << 9) & ~(1 << 18)
_9 = nil
_12 = nil
```
