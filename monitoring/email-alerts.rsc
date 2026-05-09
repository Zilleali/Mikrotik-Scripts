# ============================================
# MikroTik Email Alerts & Monitoring Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Comprehensive email alerting system for ISPs
# ============================================

# Step 1 — Configure Email Server
/tool e-mail
set server=mail.zilleali.com \
    port=587 \
    from=router@zilleali.com \
    user=router@zilleali.com \
    password=YourEmailPassword \
    tls=starttls

# Step 2 — Interface Down Alert
/system script
add name=alert-interface-down \
    source={
        :local alertEmail "admin@zilleali.com"
        :local routerName [/system identity get name]
        :local interfaces {"ether1";"ether2";"pppoe-out1"}

        :foreach iface in=$interfaces do={
            :local status [/interface get $iface running]
            :if ($status = false) do={
                /tool e-mail send \
                    to=$alertEmail \
                    subject=("[ALERT] Interface DOWN: " . $iface . " — " . $routerName) \
                    body=("CRITICAL ALERT\n\nInterface: " . $iface . \
                          "\nRouter: " . $routerName . \
                          "\nStatus: DOWN\nTime: " . [/system clock get time] . \
                          "\nDate: " . [/system clock get date] . \
                          "\n\nPlease check immediately!")
                :log error ("Interface DOWN alert sent: " . $iface)
            }
        }
    } \
    comment="Alert on interface down"

# Step 3 — High CPU Alert
/system script
add name=alert-high-cpu \
    source={
        :local alertEmail "admin@zilleali.com"
        :local routerName [/system identity get name]
        :local cpuLoad [/system resource get cpu-load]
        :local threshold 80

        :if ($cpuLoad > $threshold) do={
            /tool e-mail send \
                to=$alertEmail \
                subject=("[WARNING] High CPU: " . $cpuLoad . "% — " . $routerName) \
                body=("WARNING: High CPU Usage\n\nRouter: " . $routerName . \
                      "\nCPU Load: " . $cpuLoad . "%" . \
                      "\nThreshold: " . $threshold . "%" . \
                      "\nTime: " . [/system clock get time] . \
                      "\nDate: " . [/system clock get date])
            :log warning ("High CPU alert sent: " . $cpuLoad . "%")
        }
    } \
    comment="Alert on high CPU usage"

# Step 4 — Low Memory Alert
/system script
add name=alert-low-memory \
    source={
        :local alertEmail "admin@zilleali.com"
        :local routerName [/system identity get name]
        :local totalMem [/system resource get total-memory]
        :local freeMem [/system resource get free-memory]
        :local usedPercent (($totalMem - $freeMem) * 100 / $totalMem)

        :if ($usedPercent > 85) do={
            /tool e-mail send \
                to=$alertEmail \
                subject=("[WARNING] Low Memory: " . $usedPercent . "% — " . $routerName) \
                body=("WARNING: Low Memory\n\nRouter: " . $routerName . \
                      "\nMemory Used: " . $usedPercent . "%" . \
                      "\nFree Memory: " . $freeMem . " bytes" . \
                      "\nTime: " . [/system clock get time])
            :log warning ("Low memory alert sent: " . $usedPercent . "%")
        }
    } \
    comment="Alert on low memory"

# Step 5 — Daily Status Report
/system script
add name=daily-status-report \
    source={
        :local alertEmail "admin@zilleali.com"
        :local routerName [/system identity get name]
        :local uptime [/system resource get uptime]
        :local cpuLoad [/system resource get cpu-load]
        :local totalMem [/system resource get total-memory]
        :local freeMem [/system resource get free-memory]
        :local version [/system resource get version]

        /tool e-mail send \
            to=$alertEmail \
            subject=("[DAILY REPORT] " . $routerName . " — " . [/system clock get date]) \
            body=("Daily Status Report\n\n" . \
                  "Router: " . $routerName . "\n" . \
                  "RouterOS Version: " . $version . "\n" . \
                  "Uptime: " . $uptime . "\n" . \
                  "CPU Load: " . $cpuLoad . "%\n" . \
                  "Free Memory: " . $freeMem . " bytes\n" . \
                  "Date: " . [/system clock get date] . "\n" . \
                  "Time: " . [/system clock get time] . "\n\n" . \
                  "-- NexaLink ISP Management")

        :log info "Daily status report sent"
    } \
    comment="Send daily status report"

# Step 6 — Schedule all alerts
/system scheduler
add name=check-interfaces \
    interval=5m \
    on-event=alert-interface-down \
    comment="Check interfaces every 5 minutes"

add name=check-cpu \
    interval=10m \
    on-event=alert-high-cpu \
    comment="Check CPU every 10 minutes"

add name=check-memory \
    interval=15m \
    on-event=alert-low-memory \
    comment="Check memory every 15 minutes"

add name=daily-report \
    start-time=08:00:00 \
    interval=1d \
    on-event=daily-status-report \
    comment="Send daily report at 8 AM"

# ============================================
# Verification Commands:
# /system script print
# /system scheduler print
# /tool e-mail send to="test@email.com" subject="Test" body="Test"
# ============================================
