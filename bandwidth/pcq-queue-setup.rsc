# ============================================
# MikroTik PCQ Queue Setup for ISPs
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# PCQ = Per Connection Queuing
# Fair bandwidth distribution for ISP clients
# ============================================

# Step 1 — Create PCQ Queue Types
/queue type
add name=pcq-download \
    kind=pcq \
    pcq-classifier=dst-address \
    pcq-rate=0 \
    pcq-limit=50KiB \
    pcq-total-limit=2000KiB \
    comment="PCQ Download Queue"

add name=pcq-upload \
    kind=pcq \
    pcq-classifier=src-address \
    pcq-rate=0 \
    pcq-limit=50KiB \
    pcq-total-limit=2000KiB \
    comment="PCQ Upload Queue"

# Step 2 — Create Simple Queue with PCQ
/queue simple
add name=ISP-Bandwidth-Control \
    target=192.168.100.0/24 \
    max-limit=100M/100M \
    queue=pcq-upload/pcq-download \
    comment="ISP PCQ Bandwidth Control"

# Step 3 — Queue Tree (Advanced — optional)
/queue tree
add name=download-root \
    parent=global \
    max-limit=100M \
    packet-mark=download \
    comment="Download Root Queue"

add name=upload-root \
    parent=global \
    max-limit=100M \
    packet-mark=upload \
    comment="Upload Root Queue"

# Step 4 — Mangle rules for queue tree
/ip firewall mangle
add chain=forward \
    src-address=192.168.100.0/24 \
    action=mark-packet \
    new-packet-mark=upload \
    passthrough=no \
    comment="Mark upload traffic"

add chain=forward \
    dst-address=192.168.100.0/24 \
    action=mark-packet \
    new-packet-mark=download \
    passthrough=no \
    comment="Mark download traffic"

# ============================================
# Verification Commands:
# /queue simple print
# /queue tree print
# /queue type print
# ============================================
