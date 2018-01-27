---
layout: post
title: 利用strongSwan搭建IKEv2
date: 2016-11-26
author: Moon
tags: [VPN]
description: 利用strongSwan搭建IKEv2
---

##### 编译安装 strongSwan
```bash
wget https://download.strongswan.org/strongswan-5.5.1.tar.gz
tar zxvf strongswan-5.5.1tar.gz
cd strongswan-5.5.1
./configure --prefix=/usr --sysconfdir=/etc  --enable-openssl --enable-nat-transport --disable-mysql --disable-ldap  --disable-static --enable-shared --enable-md4 --enable-eap-mschapv2 --enable-eap-aka --enable-eap-aka-3gpp2  --enable-eap-gtc --enable-eap-identity --enable-eap-md5 --enable-eap-peap --enable-eap-radius --enable-eap-sim --enable-eap-sim-file --enable-eap-simaka-pseudonym --enable-eap-simaka-reauth --enable-eap-simaka-sql --enable-eap-tls --enable-eap-tnc --enable-eap-ttls
make
make install
```
==如果提示==`configure: error: OpenSSL libcrypto not found`需要手动安装
```bash
apt-get install libssl-dev
```

##### strongSwan 配置
```bash
# /etc/ipsec.conf
# ipsec.conf - strongSwan IPsec configuration file
# basic configuration
config setup  
    strictcrlpolicy=no
    uniqueids = no

# IKEv2 for iOS
conn iOS-IKEV2  
    auto=add
    dpdaction=clear
    keyexchange=ikev2
    #left
    left=%any
    leftsubnet=0.0.0.0/0
    leftauth=psk
    leftid=`YOUR_LEFT_ID`
    #right
    right=%any
    rightsourceip=10.99.1.0/24
    rightauth=eap-mschapv2
    rightid=YOUR_RIGHT_ID
```
配置好以后通过`ipsec reload`重新加载.
```bash
# /etc/strongswan.conf
charon {  
        load_modular = yes
        dns1 = 8.8.8.8
        dns2 = 8.8.4.4
        plugins {
                include strongswan.d/charon/*.conf
        }
}

include strongswan.d/*.conf
```
##### 密码验证
```bash
# /etc/ipsec.secrets
: PSK YOURPSK
user0 : EAP "password"  
user1 : EAP "password"  
```
配置好以后通过`ipsec rereadsecrets`重新加载.
##### 防火墙配置
```bash
iptables -A INPUT -p udp --dport 500 -j ACCEPT  
iptables -A INPUT -p udp --dport 4500 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.99.1.0/24 -o eth0 -j MASQUERADE  
iptables -A FORWARD -s 10.99.1.0/24 -j ACCEPT
```
##### mobileconfig
```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>IKEv2</key>
			<dict>
				<key>AuthName</key>
				<string>[username]</string>
				<key>AuthPassword</key>
				<string>[password]</string>
				<key>AuthenticationMethod</key>
				<string>SharedSecret</string>
				<key>ChildSecurityAssociationParameters</key>
				<dict>
					<key>DiffieHellmanGroup</key>
					<integer>2</integer>
					<key>EncryptionAlgorithm</key>
					<string>3DES</string>
					<key>IntegrityAlgorithm</key>
					<string>SHA1-96</string>
					<key>LifeTimeInMinutes</key>
					<integer>1440</integer>
				</dict>
				<key>OnDemandEnabled</key>
                <integer>1</integer>
                <key>OnDemandRules</key>
                <array>
                    <!--
                         1. Check if we are connected to a WiFi network
                         2. Check if the SSID is included in the SSIDMatch-array
                         3. If 1 + 2 are true, then disconnect the tunnel
                    -->
                    <dict>
                        <key>InterfaceTypeMatch</key>
                        <string>WiFi</string>
                        <key>SSIDMatch</key>
                        <array>
                            <string>MySSID</string>
                        </array>
                        <key>Action</key>
                        <string>Disconnect</string>
                    </dict>
                    <!--
                         1. For each connection attempt, test if the domain name is included in the Domains-array
                         2. If 1 is true, try domain name resolution
                         3. If 2 fails or times out, establish a VPN connection
                    -->
                    <dict>
                        <key>Action</key>
                        <string>EvaluateConnection</string>
                        <key>ActionParameters</key>
                        <array>
                            <dict>
                                <key>Domains</key>
                                <array>
                                    <string>*.google.com</string>
                                    <string>*.twitter.com</string>
                                    <string>*.googleapis.com</string>
                                    <string>*.instgram.com</string>
                                    <string>*.telegram.com</string>
                                    <string>*.tumblr.com</string>
                                </array>
                                <key>DomainAction</key>
                                <string>ConnectIfNeeded</string>
                            </dict>
                        </array>
                    </dict>
                    <!--
                        Default entry, ignore any other cases
                    -->
                    <dict>
                        <key>Action</key>
                        <string>Ignore</string>
                    </dict>
                </array>
				<key>DeadPeerDetectionRate</key>
				<string>Medium</string>
				<key>DisableMOBIKE</key>
				<integer>0</integer>
				<key>DisableRedirect</key>
				<integer>0</integer>
				<key>EnableCertificateRevocationCheck</key>
				<integer>0</integer>
				<key>EnablePFS</key>
				<integer>0</integer>
				<key>ExtendedAuthEnabled</key>
				<true/>
				<key>IKESecurityAssociationParameters</key>
				<dict>
					<key>DiffieHellmanGroup</key>
					<integer>2</integer>
					<key>EncryptionAlgorithm</key>
					<string>3DES</string>
					<key>IntegrityAlgorithm</key>
					<string>SHA1-96</string>
					<key>LifeTimeInMinutes</key>
					<integer>1440</integer>
				</dict>
				<key>LocalIdentifier</key>
				<string>[YOUR_RIGHT_ID]</string>
				<key>RemoteAddress</key>
				<string>[YOUR_SERVER]</string>
				<key>RemoteIdentifier</key>
				<string>[YOUR_LEFT_ID]</string>
				<key>SharedSecret</key>
				<string>[YOUR_PSK]</string>
				<key>UseConfigurationAttributeInternalIPSubnet</key>
				<integer>0</integer>
			</dict>
			<key>IPv4</key>
			<dict>
				<key>OverridePrimary</key>
				<integer>1</integer>
			</dict>
			<key>PayloadDescription</key>
			<string>Configures VPN settings</string>
			<key>PayloadDisplayName</key>
			<string>VPN</string>
			<key>PayloadIdentifier</key>
			<string>com.apple.vpn.managed.FBFBDEF8-5B16-4863-91C1-7E2A68F848A3</string>
			<key>PayloadType</key>
			<string>com.apple.vpn.managed</string>
			<key>PayloadUUID</key>
			<string>425A1628-E99B-4547-966E-5B967CF1F5EA</string>
			<key>PayloadVersion</key>
			<real>1</real>
			<key>Proxies</key>
			<dict>
				<key>HTTPEnable</key>
				<integer>0</integer>
				<key>HTTPSEnable</key>
				<integer>0</integer>
			</dict>
			<key>UserDefinedName</key>
			<string>IKEv2</string>
			<key>VPNType</key>
			<string>IKEv2</string>
			<key>VendorConfig</key>
			<dict/>
		</dict>
	</array>
	<key>PayloadDisplayName</key>
	<string>IKEv2</string>
	<key>PayloadIdentifier</key>
	<string>C7918ABA-8DE8-40ED-A3AE-994CD40ACE22</string>
	<key>PayloadRemovalDisallowed</key>
	<false/>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>9697F3C2-FF20-4981-A0C4-AA36BA78EEEA</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
</dict>
</plist>
```
