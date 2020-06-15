---
layout: post
title: 给我的 Macbook Pro 配置外接显卡
date: 2018-12-27 11:20 +0800
tags:   Apple
description: 给我的 Macbook Pro 配置外接显卡
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

MacBook Pro虽然被苹果标榜为生产力工具,但是毕竟是笔记本.  
CPU性能还算能过得去吧,虽然在神奇的散热设计加成下战斗力并不能完全发挥出来.  
相比CPU最大的问题还是GPU的性能.  

2018款MacBook Pro内建GPU为Radeon Pro 560X, 作开发播放视频浏览网页对GPU需求并不大所以就算运行的是内建的UHD Graphics 630核显也不会有什么问题.  
但是偶尔我还玩一下World of Warcraft,这就很尴尬了.  
而且通常在家我都会外接4k显示器,在将游戏特效降到最低以后还需要将模型渲染比例设定为2k才可以勉强运行8.0版本的World of Warcraft.  

虽然World of Warcraft是公认的一个CPU游戏,不过通过观察GPU负载我还是确认提升GPU性能可以非常显著的提升运行World of Warcraft的体验.  
同时我也在战网讨论中确认了这个猜想[https://us.battle.net/forums/en/wow/topic/20765096767](https://us.battle.net/forums/en/wow/topic/20765096767).  

于是开始计划购置对应的硬件.  
Apple Store直接提供了成品:  
* Blackmagic eGPU  
内建RX 580, 价格5998.00
* Blackmagic eGPU Pro  
内建vega 56, 价格10798.00  
~~家里有矿的话可以考虑~~

#### 准备
* GPU

显卡由于苹果一直不给Nvidia的10.14版本Web Driver签名,所以除非我愿意安装10.13否则我只能老老实实选择A卡.  
> 详细的支持在苹果的eGPU支持页面有列出[Use an external graphics processor with your Mac](https://support.apple.com/en-us/HT208544).  

最终选择了华硕的ROG STRIX-RXVEGA64-O8G-GAMING 1298-1590MHz.  
> 苹果文档中推荐蓝宝石品牌的显卡,不过通过搜索确认这款华硕的显卡也可以正常支持. [https://www.reddit.com/r/eGPU/comments/93uxbk/my_setup_2018_15_macbook_pro_razer_core_x_vega_64/](https://www.reddit.com/r/eGPU/comments/93uxbk/my_setup_2018_15_macbook_pro_razer_core_x_vega_64/)

* 显卡坞

选择了vega64这样的电老虎,那么显卡坞的选择面就很窄了.  
> egpu.io上有 [buyer’s guide](https://egpu.io/external-gpu-buyers-guide-2018/)  

最后选择了Razer Core X,因为是前面提到的链接中使用的显卡坞并且价格也可以接受,并且这款显卡坞同时也可以为MacBook Pro提供电源.  
京东和淘宝价格2600-2700,不过因为这款显卡坞并没有在中国大陆发售与其在淘宝或者京东第三方购买不如去闲鱼碰碰运气.  
果然,我在咸鱼拿下这款显卡坞的价格是1900.  
显卡坞大小和重量都很夸张.

#### 安装
显卡坞和显卡都到位以后就是安装了,安装很简单插上该插的接上该接的就完成.  
唯一需要注意的是这款显卡坞原装的雷电3数据线只有0.5米.(网上有说雷电3数据线不能太长,如果太长的话成本会显著上升.)  
如果需要自购置雷电3数据线的话还是推荐caldigit的雷电3数据线,这是为了保证带宽+电压.  

#### 体验
安装好以后直接上手,意料之中可以在4k分辨率下将World of Warcraft的特效开到8的同时拥有60-70FPS的体验.  

> 顺便一说,我办公室的一台PC,i7 5820k + gtx 1080ti在1080分辨率下也在游戏中的很多位置无法稳定60FPS.  

同时,在使用外置显卡运行的情况下MacBook Pro本身的热量得到了**非常显著的改善**,毕竟内建GPU和核显工作都停止了.  
在室温15摄氏度的情况下MacBook Pro的CPU温度最高在60-70摄氏度,显卡温度最高在70-75摄氏度.笔记本风扇还是和仅亮屏的时候一样的2000多转.  
> 以前用2015版MacBook Pro玩World of Warcraft的时候你会以为身边有什么东西要起飞了.

另外一个是噪音,全负荷的时候风扇声音是有的,但哪怕就在桌上也完全可以接受.

#### 最后
因为主要使用Mac,同时偶尔玩的游戏也只有World of Warcraft所以决定这么玩.  
真要玩游戏还是配一台PC吧.


拆箱前的合影,可以看出和全长的显卡比起来显卡坞实在是太大了.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/12/IMG_0062.webp">
  <img class="image" src="/images/2018/12/IMG_0062.jpeg">
</picture>

安装好以后,画质有点渣但还是可以看出来比很多ITX机箱还大.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/12/IMG_0066.webp">
  <img class="image" src="/images/2018/12/IMG_0066.jpg">
</picture>

插上后不需要作额外的操作直接就显示GPU为vega64了.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/12/about0.webp">
  <img class="image" src="/images/2018/12/about0.png">
</picture>

World of Warcraft 4k分辨率下特效开到8.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/12/wow0.webp">
  <img class="image" src="/images/2018/12/wow0.jpg">
</picture>

上个版本的显卡测试位,公司的1080ti在1080分辨率下只有不到30FPS.
<picture class="picture">
  <source type="image/webp" srcset="/images/2018/12/wow1.webp">
  <img class="image" src="/images/2018/12/wow1.jpg">
</picture>
