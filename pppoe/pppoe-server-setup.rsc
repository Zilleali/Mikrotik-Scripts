# MikroTik PPPoE Server Setup
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x

# Step 1 — Create IP Pool
/ip pool
add name=pppoe-pool ranges=192.168.100.10-192.168.100.254

# Step 2 — PPPoE Profile
/ppp profile
add name=pppoe-profile \
    local-address=192.168.100.1 \
    remote-address=pppoe-pool \
    dns-server=8.8.8.8,8.8.4.4 \
    use-encryption=yes \
    rate-limit=10M/10M \
    comment="Default ISP PPPoE Profile"

# Step 3 — PPPoE Server
/interface pppoe-server server
add service-name=ISP \
    interface=ether1 \
    default-profile=pppoe-profile \
    enabled=yes \
    authentication=chap,mschap2 \
    comment="Main PPPoE Server"

# Step 4 — Add Test User
/ppp secret
add name=testuser \
    password=testpass123 \
    service=pppoe \
    profile=pppoe-profile \
    comment="Test PPPoE User"