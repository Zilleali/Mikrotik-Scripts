# ============================================
# MikroTik Hotspot Setup Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# DISCLAIMER: Test in lab before production
# Backup first: /system backup save
# ============================================

# Step 1 — Create Hotspot IP Pool
/ip pool
add name=hotspot-pool ranges=10.10.10.2-10.10.10.254 \
    comment="Hotspot Client Pool"

# Step 2 — Hotspot IP Address on interface
/ip address
add address=10.10.10.1/24 interface=bridge-hotspot \
    comment="Hotspot Gateway"

# Step 3 — Hotspot Server Profile
/ip hotspot profile
add name=hotspot-profile \
    hotspot-address=10.10.10.1 \
    dns-name=hotspot.zilleali.com \
    html-directory=hotspot \
    login-by=cookie,http-chap \
    http-cookie-lifetime=1d \
    rate-limit=5M/5M \
    comment="Default Hotspot Profile"

# Step 4 — Hotspot Server
/ip hotspot
add name=hotspot1 \
    interface=bridge-hotspot \
    address-pool=hotspot-pool \
    profile=hotspot-profile \
    idle-timeout=1h \
    keepalive-timeout=none \
    comment="Main Hotspot Server"

# Step 5 — Hotspot User Profile
/ip hotspot user profile
add name=free-users \
    rate-limit=2M/2M \
    session-timeout=2h \
    shared-users=1 \
    comment="Free Users Profile"

add name=vip-users \
    rate-limit=10M/10M \
    session-timeout=8h \
    shared-users=1 \
    comment="VIP Users Profile"

# Step 6 — Add Test Users
/ip hotspot user
add name=guest \
    password=guest123 \
    profile=free-users \
    comment="Guest Test User"

add name=vip \
    password=vip123 \
    profile=vip-users \
    comment="VIP Test User"

# Step 7 — Disable Hardware Offloading
# IMPORTANT: Required for hotspot to work properly
/interface bridge
set [find] hw=no comment="HW offload disabled for hotspot"

# ============================================
# Verification Commands:
# /ip hotspot print
# /ip hotspot user print
# /ip hotspot active print
# ============================================
