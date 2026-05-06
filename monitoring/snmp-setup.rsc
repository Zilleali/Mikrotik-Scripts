# ============================================
# MikroTik SNMP Setup Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# For use with: LibreNMS, Zabbix, PRTG
# ============================================

# Step 1 — Enable SNMP
/snmp
set enabled=yes \
    contact="Zill E Ali — info@zilleali.com" \
    location="Gujrat, Pakistan" \
    engine-id-suffix=zilleali \
    trap-version=2 \
    trap-generators=temp-exception

# Step 2 — SNMP Community
/snmp community
set [find default=yes] \
    name=public \
    read-access=yes \
    write-access=no \
    authentication-protocol=MD5 \
    encryption-protocol=DES

# Add custom community (more secure)
add name=monitoring \
    read-access=yes \
    write-access=no \
    addresses=192.168.1.0/24 \
    comment="Monitoring Server Access"

# Step 3 — Email Alert Setup
/tool e-mail
set server=mail.zilleali.com \
    port=587 \
    from=router@zilleali.com \
    user=router@zilleali.com \
    password=YourEmailPassword \
    tls=starttls

# Step 4 — Interface Monitoring Script
/system script
add name=link-monitor \
    source={
        :local iface "ether1"
        :local status [/interface get $iface running]
        :if ($status = false) do={
            /tool e-mail send \
                to="admin@zilleali.com" \
                subject="ALERT: $iface is DOWN" \
                body="Interface $iface on router is DOWN. Please check immediately."
        }
    } \
    comment="Monitor ether1 link status"

# Step 5 — Schedule monitoring script
/system scheduler
add name=link-monitor-schedule \
    interval=5m \
    on-event=link-monitor \
    comment="Run link monitor every 5 minutes"

# Step 6 — Netwatch for external monitoring
/tool netwatch
add host=8.8.8.8 \
    interval=1m \
    timeout=1s \
    up-script="" \
    down-script={
        /tool e-mail send \
            to="admin@zilleali.com" \
            subject="ALERT: Internet DOWN" \
            body="Internet connectivity lost. Gateway 8.8.8.8 unreachable."
    } \
    comment="Monitor internet connectivity"

# ============================================
# Verification Commands:
# /snmp print
# /snmp community print
# /tool netwatch print
# ============================================
