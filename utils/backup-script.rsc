# ============================================
# MikroTik Automated Backup Script
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================

# Step 1 — Backup Script
/system script
add name=auto-backup \
    source={
        # Variables
        :local backupName ([/system identity get name] . "-" . \
            [:pick [/system clock get date] 0 3] . \
            [:pick [/system clock get date] 4 6] . \
            [:pick [/system clock get date] 7 11])

        # Create backup
        /system backup save name=$backupName
        /export file=$backupName

        # Send backup via email
        :delay 5s
        /tool e-mail send \
            to="admin@zilleali.com" \
            subject=("Backup: " . $backupName) \
            body=("Automated backup from " . \
                [/system identity get name] . \
                " on " . [/system clock get date]) \
            file=($backupName . ".backup")

        # Log backup
        :log info ("Backup completed: " . $backupName)

        # Delete old backups (keep last 5)
        :local backupFiles [/file find where name~".backup"]
        :local fileCount [:len $backupFiles]
        :if ($fileCount > 5) do={
            /file remove [lindex $backupFiles 0]
        }
    } \
    comment="Automated daily backup with email"

# Step 2 — Schedule Daily Backup
/system scheduler
add name=daily-backup \
    start-time=02:00:00 \
    interval=1d \
    on-event=auto-backup \
    comment="Daily backup at 2 AM"

# Step 3 — Manual Backup Command
# Run anytime: /system script run auto-backup

# ============================================
# Verification Commands:
# /system script print
# /system scheduler print
# /file print
# ============================================
