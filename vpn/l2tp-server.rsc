# ============================================
# MikroTik L2TP/IPSec VPN Server Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# L2TP with IPSec for secure remote access
# ============================================

# Step 1 — Enable L2TP Server
/interface l2tp-server server
set enabled=yes \
    use-ipsec=required \
    ipsec-secret=YourIPSecSecret123 \
    authentication=mschap2 \
    default-profile=l2tp-profile \
    comment="L2TP/IPSec VPN Server"

# Step 2 — Create L2TP IP Pool
/ip pool
add name=l2tp-pool \
    ranges=10.9.0.2-10.9.0.254 \
    comment="L2TP VPN Client Pool"

# Step 3 — Create L2TP Profile
/ppp profile
add name=l2tp-profile \
    local-address=10.9.0.1 \
    remote-address=l2tp-pool \
    dns-server=8.8.8.8,8.8.4.4 \
    use-encryption=yes \
    only-one=yes \
    comment="L2TP VPN Profile"

# Step 4 — Add VPN Users
/ppp secret
add name=vpnuser1 \
    password=SecurePass123 \
    service=l2tp \
    profile=l2tp-profile \
    comment="VPN User 1"

add name=vpnuser2 \
    password=SecurePass456 \
    service=l2tp \
    profile=l2tp-profile \
    comment="VPN User 2"

# Step 5 — Firewall rules for L2TP
/ip firewall filter
add chain=input \
    protocol=udp \
    dst-port=500,1701,4500 \
    action=accept \
    comment="Allow L2TP/IPSec ports"

add chain=input \
    protocol=ipsec-esp \
    action=accept \
    comment="Allow IPSec ESP"

add chain=input \
    in-interface=l2tp-server \
    action=accept \
    comment="Allow L2TP tunnel traffic"

# Step 6 — NAT for VPN clients
/ip firewall nat
add chain=srcnat \
    src-address=10.9.0.0/24 \
    out-interface=ether1 \
    action=masquerade \
    comment="NAT for L2TP VPN clients"

# ============================================
# Client Setup (Windows):
# Type: L2TP/IPSec with pre-shared key
# Server: YOUR_ROUTER_PUBLIC_IP
# Pre-shared key: YourIPSecSecret123
# Username/Password: vpnuser1/SecurePass123
# ============================================
# Verification Commands:
# /interface l2tp-server server print
# /ppp active print
# /ppp secret print
# ============================================
