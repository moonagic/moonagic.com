---
layout: post
title: Stop DHCP From Changing resolv.conf
date: 2018-06-19 16:19 +0800
tags:   Linux VPS DNS
author: 月杪
---

> For DHCP users, there may be times when you need to edit /etc/resolv.conf to use other nameservers. Then, after a period of time (or after a system reboot), you discover that your changes to /etc/resolv.conf have been reverted.

This tutorial shows three methods to stop DHCP from changing the /etc/resolv.conf on Debian or Ubuntu.

#### Method 1: Change interface settings to static
* On a cloud vps, I do not suggest using this method.
* If you use this method, you may find that the reboot processing (until you can login through ssh) takes longer.

First, we need to get the IP/netmask/gateway of the server. Run the following command.

```zsh
ifconfig | grep "inet addr" | head -n 1 | awk '{print $2, $4}'
addr:1.2.3.4 Mask:255.255.254.0
```

... the server IP address is 1.2.3.4 and mask is 255.255.254.0.

To get the gateway address, run the following command.

```zsh
netstat -rn | grep '^0.0.0.0' | awk '{print $2}'
```

In this example, I will use the gateway address 1.2.3.1.

Now that we have the **IP/netmask/gateway**, edit `/etc/network/interfaces`.

```zsh
 vim /etc/network/interfaces
```
Make the following edits:
```zsh
# Comment out this line
# iface eth0 inet dhcp

# Add these contents
iface eth0 inet static
address 1.2.3.4
mask 255.255.254.0
gateway 1.2.3.1
```

Remember, you must replace these values with the appropriate **IP/netmask/gateway** of server.

Save and exit, then reboot.

#### Method 2: Write protect your nameservers
Change your nameservers by editing `/etc/resolv.conf`. Once you have made your edits, write protect that file.

```zsh
chattr +i /etc/resolv.conf
```

The `+i` option (attribute) write protects the `/etc/resolv.conf` file on Linux so that no one can modify it - not even the root user.

If you need to remove the write protect attribute, use the following command.

```zsh
chattr -i /etc/resolv.conf
```

#### Method 3: Use DHCP hooks
This is the method that I recommend using the most.

Edit `/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate`.

```zsh
vim /etc/dhcp/dhclient-enter-hooks.d/nodnsupdate
```

Make the following edits:

```zsh
#!/bin/sh
make_resolv_conf(){
    :
}
```

Save and exit.

Update the permissions on the `nodnsupdate` file.

```zsh
chmod +x /etc/dhcp/dhclient-enter-hooks.d/nodnsupdate
```

Reboot your server. You can now update nameservers by editing /etc/resolv.conf without worrying about rollback.
