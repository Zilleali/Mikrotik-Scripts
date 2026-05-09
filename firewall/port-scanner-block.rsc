# ============================================
# MikroTik Port Scanner Block Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Automatically detects and blocks port scanners
# using dynamic address lists
# ============================================

# Step 1 — Create scanner address list
/ip firewall address-list
add list=port-scanners comment="Auto-detected port scanners"
add list=scan-stage1 comment="Stage 1 — First scan detected"
add list=scan-stage2 comment="Stage 2 — Multiple ports scanned"
add list=scan-stage3 comment="Stage 3 — Confirmed scanner"

# Step 2 — Detect port scanning stages
/ip firewall filter

# Stage 1 — First suspicious connection
add chain=input protocol=tcp \
    psd=21,3s,3,1 \
    action=add-src-to-address-list \
    address-list=scan-stage1 \
    address-list-timeout=1m \
    comment="Port Scan Stage 1 — Detect"

# Stage 2 — Multiple port attempts
add chain=input protocol=tcp \
    src-address-list=scan-stage1 \
    action=add-src-to-address-list \
    address-list=scan-stage2 \
    address-list-timeout=2m \
    comment="Port Scan Stage 2 — Escalate"

# Stage 3 — Confirmed scanner
add chain=input protocol=tcp \
    src-address-list=scan-stage2 \
    action=add-src-to-address-list \
    address-list=scan-stage3 \
    address-list-timeout=24h \
    comment="Port Scan Stage 3 — Confirmed"

# Block confirmed scanners
add chain=input \
    src-address-list=scan-stage3 \
    action=add-src-to-address-list \
    address-list=port-scanners \
    address-list-timeout=7d \
    comment="Add to permanent blacklist"

add chain=input \
    src-address-list=port-scanners \
    action=drop \
    comment="Drop all port scanners"

add chain=forward \
    src-address-list=port-scanners \
    action=drop \
    comment="Drop scanner forward traffic"

# Step 3 — Block common scan ports
add chain=input protocol=tcp \
    dst-port=23,3389,5900,4899 \
    action=add-src-to-address-list \
    address-list=port-scanners \
    address-list-timeout=7d \
    comment="Block Telnet/RDP/VNC scanners"

# ============================================
# Verification Commands:
# /ip firewall address-list print where list=port-scanners
# /ip firewall filter print
# ============================================
