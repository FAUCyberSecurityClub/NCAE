#!/bin/bash

# 1. Flush all current rules and delete custom chains
iptables -F
iptables -X

# 2. Set default policies (Secure by default: Drop inbound, Allow outbound)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 3. Allow internal loopback traffic (Required for local services to talk to each other)
iptables -A INPUT -i lo -j ACCEPT

# 4. Allow return traffic for established connections 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 5. Allow SSH (Port 22) - So you don't lock yourself out!
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 6. Allow DNS (Port 53 TCP/UDP)
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# 7. Allow SMB (Port 139/445 TCP, Port 137/138 UDP for NetBIOS)
iptables -A INPUT -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -p udp --dport 137 -j ACCEPT
iptables -A INPUT -p udp --dport 138 -j ACCEPT

echo "[+] iptables configured: DNS, SMB, and SSH allowed. All other inbound traffic DROPPED."
