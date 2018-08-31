---
layout: post
title: 快速统计项目代码行数
date: 2017-06-11
tags: [技巧]
description: 快速统计项目代码行数
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---

```bash
$ find . -name "*.swift" -or -name "*.h" | xargs wc -l
    59 ./mas-cli/AppStore/Downloader.swift
    62 ./mas-cli/AppStore/ISStoreAccount.swift
   114 ./mas-cli/AppStore/PurchaseDownloadObserver.swift
    29 ./mas-cli/AppStore/SSPurchase.swift
    24 ./mas-cli/Commands/Account.swift
    58 ./mas-cli/Commands/Install.swift
    25 ./mas-cli/Commands/List.swift
    27 ./mas-cli/Commands/Outdated.swift
    85 ./mas-cli/Commands/Reset.swift
    63 ./mas-cli/Commands/Search.swift
    59 ./mas-cli/Commands/SignIn.swift
    18 ./mas-cli/Commands/SignOut.swift
    65 ./mas-cli/Commands/Upgrade.swift
    21 ./mas-cli/Commands/Version.swift
    64 ./mas-cli/Error.swift
    34 ./mas-cli/main.swift
    44 ./mas-cli/mas-cli-Bridging-Header.h
    63 ./mas-cli/NSURLSession+Synchronous.swift
    37 ./mas-cli/PrivateHeaders/CommerceKit/CKAccountStore.h
    41 ./mas-cli/PrivateHeaders/CommerceKit/CKDownloadQueue.h
    38 ./mas-cli/PrivateHeaders/CommerceKit/CKPurchaseController.h
    14 ./mas-cli/PrivateHeaders/CommerceKit/CKServiceInterface.h
    37 ./mas-cli/PrivateHeaders/CommerceKit/CKSoftwareMap.h
    59 ./mas-cli/PrivateHeaders/CommerceKit/CKUpdateController.h
    17 ./mas-cli/PrivateHeaders/CommerceKit/ISStoreURLOperationDelegate-Protocol.h
    73 ./mas-cli/PrivateHeaders/StoreFoundation/CKSoftwareProduct.h
    42 ./mas-cli/PrivateHeaders/StoreFoundation/CKUpdate.h
    53 ./mas-cli/PrivateHeaders/StoreFoundation/ISAccountService-Protocol.h
    53 ./mas-cli/PrivateHeaders/StoreFoundation/ISAuthenticationContext.h
    16 ./mas-cli/PrivateHeaders/StoreFoundation/ISOperationDelegate-Protocol.h
    51 ./mas-cli/PrivateHeaders/StoreFoundation/ISServiceProxy.h
    13 ./mas-cli/PrivateHeaders/StoreFoundation/ISServiceRemoteObject-Protocol.h
    53 ./mas-cli/PrivateHeaders/StoreFoundation/ISStoreAccount.h
    74 ./mas-cli/PrivateHeaders/StoreFoundation/ISStoreClient.h
    18 ./mas-cli/PrivateHeaders/StoreFoundation/ISURLOperationDelegate-Protocol.h
    60 ./mas-cli/PrivateHeaders/StoreFoundation/SSDownload.h
    73 ./mas-cli/PrivateHeaders/StoreFoundation/SSDownloadMetadata.h
    30 ./mas-cli/PrivateHeaders/StoreFoundation/SSDownloadPhase.h
    37 ./mas-cli/PrivateHeaders/StoreFoundation/SSDownloadStatus.h
    67 ./mas-cli/PrivateHeaders/StoreFoundation/SSPurchase.h
    26 ./mas-cli/PrivateHeaders/StoreFoundation/SSPurchaseResponse.h
    51 ./mas-cli/Utilities.swift
    95 ./Seeds/Commandant/Sources/Commandant/Argument.swift
   191 ./Seeds/Commandant/Sources/Commandant/ArgumentParser.swift
    41 ./Seeds/Commandant/Sources/Commandant/ArgumentProtocol.swift
   224 ./Seeds/Commandant/Sources/Commandant/Command.swift
    17 ./Seeds/Commandant/Sources/Commandant/Commandant.h
   147 ./Seeds/Commandant/Sources/Commandant/Errors.swift
    75 ./Seeds/Commandant/Sources/Commandant/HelpCommand.swift
    14 ./Seeds/Commandant/Sources/Commandant/LinuxSupport.swift
   214 ./Seeds/Commandant/Sources/Commandant/Option.swift
    63 ./Seeds/Commandant/Sources/Commandant/Switch.swift
     8 ./Seeds/Result/Result/Result.h
   192 ./Seeds/Result/Result/Result.swift
   182 ./Seeds/Result/Result/ResultProtocol.swift
  3410 total
```