# ============================================
# MikroTik User Manager Configuration Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Requires User Manager package installed
# /system package print | grep user-manager
# ============================================

# Step 1 — Enable User Manager
/user-manager
set enabled=yes \
    certificate=none

# Step 2 — Configure RADIUS for User Manager
/radius
add service=hotspot \
    address=127.0.0.1 \
    secret=radiussecret123 \
    comment="Local User Manager RADIUS"

# Step 3 — Create User Manager Profiles
/user-manager profile
add name=basic-plan \
    name-for-users="Basic Plan" \
    validity=30d \
    starts=first-auth \
    price=500 \
    comment="Basic 30-day plan"

add name=unlimited-plan \
    name-for-users="Unlimited Plan" \
    validity=30d \
    starts=first-auth \
    price=1000 \
    comment="Unlimited 30-day plan"

# Step 4 — Create Profile Limitations
/user-manager profile limitation
add name=basic-limit \
    rate-limit-rx=5M \
    rate-limit-tx=5M \
    transfer-limit=50G \
    comment="Basic plan limits — 5Mbps, 50GB"

add name=unlimited-limit \
    rate-limit-rx=20M \
    rate-limit-tx=20M \
    comment="Unlimited plan — 20Mbps no data cap"

# Step 5 — Associate limitations with profiles
/user-manager profile profile-limitation
add profile=basic-plan \
    limitation=basic-limit \
    from-time=0s \
    till-time=23h59m59s \
    weekdays=sunday,monday,tuesday,wednesday,thursday,friday,saturday

add profile=unlimited-plan \
    limitation=unlimited-limit \
    from-time=0s \
    till-time=23h59m59s \
    weekdays=sunday,monday,tuesday,wednesday,thursday,friday,saturday

# Step 6 — Create test users
/user-manager user
add username=testbasic \
    password=test123 \
    profile=basic-plan \
    comment="Test basic plan user"

add username=testunlimited \
    password=test123 \
    profile=unlimited-plan \
    comment="Test unlimited plan user"

# Step 7 — Configure Router for User Manager
/user-manager router
add name=main-router \
    address=127.0.0.1 \
    shared-secret=radiussecret123 \
    comment="Main hotspot router"

# ============================================
# Verification Commands:
# /user-manager print
# /user-manager profile print
# /user-manager user print
# /user-manager session print
# ============================================
