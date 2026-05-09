# ============================================
# MikroTik PPPoE Client Monitor Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Monitors PPPoE connections and sends alerts
# for disconnections and reconnections
# ============================================

# Step 1 — PPPoE Client Monitor Script
/system script
add name=pppoe-monitor \
    source={
        :local interface "pppoe-out1"
        :local emailTo "admin@zilleali.com"
        :local routerName [/system identity get name]

        # Check PPPoE connection status
        :local status [/interface get $interface running]

        :if ($status = false) do={
            # PPPoE is DOWN — send alert
            :log warning ("PPPoE DOWN: " . $interface . " on " . $routerName)

            /tool e-mail send \
                to=$emailTo \
                subject=("ALERT: PPPoE DOWN — " . $routerName) \
                body=("PPPoE interface " . $interface . \
                      " is DOWN on " . $routerName . \
                      "\nTime: " . [/system clock get time] . \
                      "\nDate: " . [/system clock get date] . \
                      "\nPlease check your ISP connection immediately.")

            # Try to reconnect
            /interface disable $interface
            :delay 5s
            /interface enable $interface
            :log info ("PPPoE reconnection attempted: " . $interface)

        } else={
            :log info ("PPPoE OK: " . $interface . " is running")
        }
    } \
    comment="Monitor PPPoE client connection"

# Step 2 — PPPoE Statistics Logger
/system script
add name=pppoe-stats \
    source={
        :local interface "pppoe-out1"
        :local txBytes [/interface get $interface tx-byte]
        :local rxBytes [/interface get $interface rx-byte]
        :local uptime [/interface get $interface running]

        :log info ("PPPoE Stats — TX: " . $txBytes . \
                   " RX: " . $rxBytes . \
                   " Running: " . $uptime)
    } \
    comment="Log PPPoE statistics"

# Step 3 — Schedule monitoring
/system scheduler
add name=pppoe-monitor-schedule \
    interval=2m \
    on-event=pppoe-monitor \
    comment="Check PPPoE every 2 minutes"

add name=pppoe-stats-schedule \
    interval=1h \
    on-event=pppoe-stats \
    comment="Log PPPoE stats every hour"

# ============================================
# Verification Commands:
# /system script print
# /system scheduler print
# /log print where topics~"pppoe"
# ============================================
