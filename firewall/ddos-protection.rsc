# ============================================
# MikroTik DDoS Protection Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Protects against common DDoS attacks using
# dynamic address lists and rate limiting
# ============================================

# Step 1 — Create Address Lists for blocklist
/ip firewall address-list
add list=ddos-blacklist comment="DDoS Blacklist — Auto populated"
add list=ddos-whitelist address=0.0.0.0/0 comment="Whitelist — Add trusted IPs"

# Step 2 — Detect and block port scanners
/ip firewall filter

# Drop blacklisted IPs immediately
add chain=input src-address-list=ddos-blacklist action=drop \
    comment="Drop DDoS blacklisted IPs" place-before=0

add chain=forward src-address-list=ddos-blacklist action=drop \
    comment="Drop DDoS blacklisted forward" place-before=1

# Step 3 — SYN Flood protection
add chain=input protocol=tcp tcp-flags=syn connection-limit=30,32 \
    action=add-src-to-address-list address-list=ddos-blacklist \
    address-list-timeout=1d \
    comment="SYN Flood — Add to blacklist"

add chain=input protocol=tcp tcp-flags=syn \
    src-address-list=ddos-blacklist action=drop \
    comment="SYN Flood — Drop blacklisted"

# Step 4 — ICMP Flood protection
add chain=input protocol=icmp limit=50,100:packet action=accept \
    comment="Allow limited ICMP"

add chain=input protocol=icmp action=drop \
    comment="Drop excessive ICMP flood"

# Step 5 — UDP Flood protection
add chain=input protocol=udp limit=200,400:packet action=accept \
    comment="Allow limited UDP"

add chain=input protocol=udp action=add-src-to-address-list \
    address-list=ddos-blacklist address-list-timeout=1h \
    comment="UDP Flood — Add to blacklist"

# Step 6 — Connection rate limiting
add chain=input connection-state=new \
    src-address-list=!ddos-whitelist \
    limit=100,200:packet action=accept \
    comment="Allow limited new connections"

add chain=input connection-state=new \
    src-address-list=!ddos-whitelist \
    action=add-src-to-address-list \
    address-list=ddos-blacklist \
    address-list-timeout=1h \
    comment="Rate limit exceeded — Add to blacklist"

# Step 7 — HTTP/HTTPS DDoS protection (for ISP web services)
add chain=input protocol=tcp dst-port=80,443 \
    connection-limit=50,32 \
    action=add-src-to-address-list \
    address-list=ddos-blacklist \
    address-list-timeout=1h \
    comment="HTTP/HTTPS flood protection"

# ============================================
# Verification Commands:
# /ip firewall address-list print where list=ddos-blacklist
# /ip firewall filter print
# ============================================
