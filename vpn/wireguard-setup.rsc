# ============================================
# MikroTik WireGuard VPN Setup Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v7.x only
# ============================================
# Note: WireGuard requires RouterOS v7.x+
# ============================================

# Step 1 — Create WireGuard Interface
/interface wireguard
add name=wireguard1 \
    listen-port=13231 \
    comment="WireGuard VPN Server"

# Step 2 — Assign IP to WireGuard interface
/ip address
add address=10.8.0.1/24 \
    interface=wireguard1 \
    comment="WireGuard Server IP"

# Step 3 — Add Peer (Client)
# Replace public-key with actual client public key
/interface wireguard peers
add interface=wireguard1 \
    public-key="CLIENT_PUBLIC_KEY_HERE" \
    allowed-address=10.8.0.2/32 \
    persistent-keepalive=25 \
    comment="VPN Client 1"

# Step 4 — Firewall rules for WireGuard
/ip firewall filter
add chain=input \
    protocol=udp \
    dst-port=13231 \
    action=accept \
    comment="Allow WireGuard UDP"

add chain=input \
    in-interface=wireguard1 \
    action=accept \
    comment="Allow WireGuard tunnel traffic"

# Step 5 — NAT for VPN clients
/ip firewall nat
add chain=srcnat \
    src-address=10.8.0.0/24 \
    out-interface=ether1 \
    action=masquerade \
    comment="NAT for WireGuard clients"

# ============================================
# Client Config Template:
# [Interface]
# PrivateKey = CLIENT_PRIVATE_KEY
# Address = 10.8.0.2/24
# DNS = 8.8.8.8
#
# [Peer]
# PublicKey = SERVER_PUBLIC_KEY
# Endpoint = YOUR_SERVER_IP:13231
# AllowedIPs = 0.0.0.0/0
# PersistentKeepalive = 25
# ============================================
# Verification Commands:
# /interface wireguard print
# /interface wireguard peers print
# ============================================
