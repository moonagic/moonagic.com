---
layout: post
title: Swift进行后端开发
date: 2017-02-25
tags: [Swift]
description: Swift进行后端开发
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

自从Swift开源以后就出现了一些可以进行后端开发的框架,主要的几个有:[Perfect](https://github.com/PerfectlySoft),[Vapor](https://github.com/vapor),[Kitura](https://github.com/IBM-Swift/Kitura)和[Zewo](https://github.com/Zewo).其中Perfect最为著名,于是就打算从它入手.

##### 环境
先跟着[https://swift.org](https://swift.org)上的文档在服务器上安装好Swift环境.

##### 官方示例
```bash
git clone https://github.com/PerfectlySoft/PerfectTemplate.git
cd PerfectTemplate
swift build
.build/debug/PerfectTemplate
```
一切正常的话就会看到类似
```bash
Starting HTTP server on 127.0.0.1:8181
```
这样的提示,表示服务已经开启

##### 选择数据库
作为一个后端小白,想选一款非MySQL的数据库,在搜索了各种介绍以后决定先从PostgreSQL入手.
在服务器上配置好PostgreSQL即可,其间过程不表.
##### 尝试添加注册登录
```Swift
# Sources/main.swift
routes.add(method: .post, uri: "/regist", handler: {
    request, response in
    let account:String = request.param(name: "account")!
    let passwd:String = request.param(name: "passwd")!
    if account != "" && passwd != "" {
        let p = PGConnection()
        let status = p.connectdb("postgresql://moon:backstreet@localhost:5432/moondb")
        
        let res = p.exec(statement: "SELECT * FROM _user_table WHERE name = '\(account)'")
        if let registed = res.getFieldString(tupleIndex: 0, fieldIndex: 0) {
            // this account was registed
            print("this account was registed")
            response.setHeader(.contentType, value: "application/json")
            let scoreArray: [String:Any] = ["code": errorCode.accountWasRegisted]
            var encoded = ""
            do {
                encoded = try scoreArray.jsonEncodedString()
            } catch {
                
            }
            response.appendBody(string: encoded)
            response.completed()
        } else {
            // go to regist
            print("go to regist")
            
            let result = p.exec(statement: "INSERT INTO _user_table(name, passwd) VALUES('\(account)', '\(passwd)';")
            print("\(result.status())")
            if result.status() == .commandOK {
                response.setHeader(.contentType, value: "application/json")
                let scoreArray: [String:Any] = ["code": 200]
                var encoded = ""
                do {
                    encoded = try scoreArray.jsonEncodedString()
                } catch {
                    
                }
                
                response.appendBody(string: encoded)
                response.completed()
            }
        }
        
        defer {
            p.finish()
        }
    }
})
routes.add(method: .post, uri: "/login", handler: {
    request, response in
    let account = request.param(name: "account")
    let passwd = request.param(name: "passwd")
    let p = PGConnection()
    let status = p.connectdb("postgresql://moon:backstreet@localhost:5432/moondb")
    
    let res = p.exec(statement: "SELECT passwd FROM _user_table WHERE name = '\(account!)'")
    if let accountP = res.getFieldString(tupleIndex: 0, fieldIndex: 0) {
        
        let accountPasswd = accountP.stringByReplacing(string: " ", withString: "")
        
        if passwd! == accountPasswd {
            var token = UUID().string
            tokenCache[account!] = token;
            // login sucsses
            response.setHeader(.contentType, value: "application/json")
            let scoreArray: [String:Any] = ["code": 200, "token": token]
            var encoded = ""
            do {
                encoded = try scoreArray.jsonEncodedString()
            } catch {
                
            }
            response.appendBody(string: encoded)
            response.completed()
            return
        } else {
            print("wrong passwd")
        }
        
    }
    // login faild
    let scoreArray: [String:Any] = ["code": 404]
    var encoded = ""
    do {
        encoded = try scoreArray.jsonEncodedString()
    } catch {
        
    }
    response.appendBody(string: encoded)
    response.completed()
})
```
发布到服务器上编译运行,然后新开另一项目进行相应的客户端编码即可顺利完成注册登录测试.

over.

##### 相关代码
[MoonServer](https://github.com/koikw/MoonServer)
