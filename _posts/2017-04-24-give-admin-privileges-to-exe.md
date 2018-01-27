---
layout: post
title: 对exe文件添加管理员执行权限
date: 2017-04-24
author: Moon
tags: [其他]
description: 对exe文件添加管理员执行权限
---

##### 起因
> 临时使用QT开发了一套类似启动器的程序,开发完毕发布给同事使用以后才发现如果安装到程序目录以后很多操作都无效了.
由于以前从未从事过win32开发(我只是个跑龙套的),只能手动排除故障..
最终发现应该是该编译出的exe文件缺少管理员权限的问题.

##### 手动创建uac文件
```xml
<!-- uac.manifest -->
<?xml version='1.0' encoding='UTF-8' standalone='yes'?>  
<assembly xmlns='urn:schemas-microsoft-com:asm.v1' manifestVersion='1.0'>  
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">  
    <security>  
      <requestedPrivileges>  
        <requestedExecutionLevel level='requireAdministrator' uiAccess='false' />  
      </requestedPrivileges>  
    </security>  
  </trustInfo>  
</assembly>
```
##### 操作
将`mt.exe` `uac.manifest` 和需要添加管理员权限的exe文件`simple.exe`放到同一个目录中执行
```bash
mt.exe -manifest "uac.manifest" -outputresource:"simple.exe"
```
执行完毕后simple.exe就应该拥有管理员权限了.