---
layout: post
title: 在Linux上使用rclone挂载Google Drive等服务
date: 2018-06-07 13:21 +0800
tags:   VPS
author: 月杪
---

> rclone可以帮助我们在Linux上挂载一些储存服务,包括Google drive, onedrive, box, AWS S3等等.同时不会占用硬盘空间

#### 安装依赖
```zsh
apt-get install fuse
```

#### 下载
```zsh
wget https://downloads.rclone.org/v1.41/rclone-v1.41-linux-amd64.zip
```
截止目前最新版为1.41,在 https://downloads.rclone.org/ 可以看到历史版本.  
下载解压后里面的可执行文件`rclone`就是我们需要的,可以直接在当前目录使用也可以将其拷贝到`/usr/local/bin`.  

#### 配置
```zsh
./rclone config  # 当前目录下执行
rclone config    # 系统目录下执行

Current remotes:

Name                 Type
====                 ====
moonagic             drive
moonkinstar          drive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q>
```
显示当前已经挂载了2个盘,需要新建的话键入n,然后输入新建盘的名字  
```zsh
Type of storage to configure.
Choose a number from below, or type in your own value
 1 / Alias for a existing remote
   \ "alias"
 2 / Amazon Drive
   \ "amazon cloud drive"
 3 / Amazon S3 Compliant Storage Providers (AWS, Ceph, Dreamhost, IBM COS, Minio)
   \ "s3"
 4 / Backblaze B2
   \ "b2"
 5 / Box
   \ "box"
 6 / Cache a remote
   \ "cache"
 7 / Dropbox
   \ "dropbox"
 8 / Encrypt/Decrypt a remote
   \ "crypt"
 9 / FTP Connection
   \ "ftp"
10 / Google Cloud Storage (this is not Google Drive)
   \ "google cloud storage"
11 / Google Drive
   \ "drive"
12 / Hubic
   \ "hubic"
13 / Local Disk
   \ "local"
14 / Mega
   \ "mega"
15 / Microsoft Azure Blob Storage
   \ "azureblob"
16 / Microsoft OneDrive
   \ "onedrive"
17 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
   \ "swift"
18 / Pcloud
   \ "pcloud"
19 / QingCloud Object Storage
   \ "qingstor"
20 / SSH/SFTP Connection
   \ "sftp"
21 / Webdav
   \ "webdav"
22 / Yandex Disk
   \ "yandex"
23 / http Connection
   \ "http"
Storage>
```
然后选择你需要挂载的服务的对应序号,比如我们现在要挂载Google Drive的话就键入11.  
```zsh
Storage> 11
Google Application Client Id - leave blank normally.
client_id>
Google Application Client Secret - leave blank normally.
client_secret>
Scope that rclone should use when requesting access from drive.
Choose a number from below, or type in your own value
 1 / Full access all files, excluding Application Data Folder.
   \ "drive"
 2 / Read-only access to file metadata and file contents.
   \ "drive.readonly"
   / Access to files created by rclone only.
 3 | These are visible in the drive website.
   | File authorization is revoked when the user deauthorizes the app.
   \ "drive.file"
   / Allows read and write access to the Application Data folder.
 4 | This is not visible in the drive website.
   \ "drive.appfolder"
   / Allows read-only access to file metadata but
 5 | does not allow any access to read or download file content.
   \ "drive.metadata.readonly"
scope>
ID of the root folder - leave blank normally.  Fill in to access "Computers" folders. (see docs).
root_folder_id>
Service Account Credentials JSON file path  - leave blank normally.
Needed only if you want use SA instead of interactive login.
service_account_file>
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine or Y didn't work
y) Yes
n) No
y/n>
```
之后的选项全部默认,一直到这一步如果你是本机挂载则选择y,是服务器的话选择n.  
```zsh
If your browser doesn't open automatically go to the following link: https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=202264815644.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=34e2987e7d777e38342a7e3680df3c1d
Log in and authorize rclone for access
Enter verification code>
```
将提示的链接从浏览器打开,授权后获取到`verification code`并键入就完成了.  
#### 挂载
现在我们已经配置好了rclone,只需要通过对应的服务名字来挂载盘就行了.如果忘记了配置时输入的名字可以再次通过`rclone config`命令来查看:
```zsh
rclone config
Current remotes:

Name                 Type
====                 ====
moonagic             drive
moonkinstar          drive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q>
```
其中的`moonagic`和`moonkinstar`都是已经配置好的服务器.  
现在我们开始挂载盘,以`moonagic`为例:

```zsh
# 先新建一个目录,用于挂载
mkdir -p /mnt/moonagic
# 挂载命令
rclone mount moonagic: /mnt/moonagic --allow-other --allow-non-empty --vfs-cache-mode writes
```
其中`moonagic:`代表该服务中的目录,这里表示将名为`moonagic`的整个Google Drive盘都挂载.  
现在通过`df -h`查看就能够看到刚才挂载的目录了.  
```zsh
df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            483M     0  483M   0% /dev
tmpfs            99M   13M   87M  13% /run
/dev/sda1       9.8G  7.6G  1.8G  82% /
tmpfs           495M     0  495M   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           495M     0  495M   0% /sys/fs/cgroup
moonagic:        30G  1.1G   29G   4% /mnt/moonagic
```

#### 总结
如果手里有大容量的Google Drive或者OneDrive可以使用rclone挂载到VPS上,将不常用的文件丢进去可以很大程度上节约空间.比如我这台服务器剩余空间只有1.8G了.    
或者你需要将数据从多个网盘或者存储服务中迁移(配置时可以看到rclone支持绝大部分主流网盘以及存储服务),rclone也是非常优秀的解决方案.  
