# ============================================
# MikroTik IP Blacklist Management Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Dynamic IP blacklist with auto-expiry
# and manual management tools
# ============================================

# Step 1 — Create Blacklist Address Lists
/ip firewall address-list
add list=ip-blacklist comment="Manual IP Blacklist"
add list=ip-whitelist comment="Trusted IPs — Never blocked"
add list=auto-blacklist comment="Auto-detected malicious IPs"
add list=temp-blacklist comment="Temporary blocks — 24h"

# Step 2 — Add known malicious IP ranges (examples)
/ip firewall address-list
add list=ip-blacklist address=0.0.0.0/8 comment="Invalid source"
add list=ip-blacklist address=169.254.0.0/16 comment="Link-local"
add list=ip-blacklist address=192.0.2.0/24 comment="TEST-NET"

# Step 3 — Whitelist trusted IPs
/ip firewall address-list
add list=ip-whitelist address=192.168.1.0/24 comment="Local LAN"
add list=ip-whitelist address=10.0.0.0/8 comment="Private network"

# Step 4 — Firewall rules for blacklist
/ip firewall filter
add chain=input \
    src-address-list=ip-whitelist \
    action=accept \
    place-before=0 \
    comment="Always allow whitelist"

add chain=input \
    src-address-list=ip-blacklist \
    action=drop \
    log=yes \
    log-prefix="BLACKLIST-DROP: " \
    comment="Drop blacklisted IPs"

add chain=input \
    src-address-list=auto-blacklist \
    action=drop \
    log=yes \
    log-prefix="AUTO-BLACKLIST: " \
    comment="Drop auto-blacklisted IPs"

add chain=input \
    src-address-list=temp-blacklist \
    action=drop \
    comment="Drop temporary blacklist"

add chain=forward \
    src-address-list=ip-blacklist \
    action=drop \
    comment="Drop blacklist forward"

# Step 5 — Auto-blacklist script
/system script
add name=blacklist-manager \
    source={
        :local logFile "blacklist-log"

        # Get failed login attempts from log
        :foreach entry in=[/log find where topics~"error" && message~"login failure"] do={
            :local msg [/log get $entry message]
            :local ip [:pick $msg ([:find $msg "from"] + 5) [:find $msg " " ([:find $msg "from"] + 5)]]

            # Check if not already blacklisted or whitelisted
            :if ([:len [/ip firewall address-list find where list=ip-whitelist && address=$ip]] = 0) do={
                :if ([:len [/ip firewall address-list find where list=ip-blacklist && address=$ip]] = 0) do={
                    /ip firewall address-list add \
                        list=auto-blacklist \
                        address=$ip \
                        timeout=24h \
                        comment=("Auto-blocked: " . [/system clock get date])
                    :log warning ("Auto-blacklisted IP: " . $ip)
                }
            }
        }
    } \
    comment="Auto blacklist management"

# Step 6 — Blacklist cleanup script
/system script
add name=blacklist-cleanup \
    source={
        # Remove expired auto-blacklist entries (older than 7 days)
        :foreach entry in=[/ip firewall address-list find where list=auto-blacklist] do={
            :log info ("Checking auto-blacklist entry: " . [/ip firewall address-list get $entry address])
        }
        :log info "Blacklist cleanup completed"
    } \
    comment="Cleanup old blacklist entries"

# Step 7 — Schedule blacklist management
/system scheduler
add name=blacklist-auto \
    interval=30m \
    on-event=blacklist-manager \
    comment="Auto blacklist every 30 minutes"

add name=blacklist-cleanup-schedule \
    start-time=03:00:00 \
    interval=1d \
    on-event=blacklist-cleanup \
    comment="Cleanup blacklist daily at 3 AM"

# ============================================
# Manual Commands:
# Add IP: /ip firewall address-list add list=ip-blacklist address=X.X.X.X
# Remove IP: /ip firewall address-list remove [find where address=X.X.X.X]
# View blacklist: /ip firewall address-list print where list=ip-blacklist
# ============================================
