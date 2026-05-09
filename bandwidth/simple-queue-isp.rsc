# ============================================
# MikroTik Simple Queue for ISP Clients
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
# ============================================
# Individual bandwidth control per subscriber
# ============================================

# Step 1 — Create Queue Types
/queue type
add name=type-5m kind=pcq pcq-classifier=dst-address \
    comment="5Mbps download type"
add name=type-10m kind=pcq pcq-classifier=dst-address \
    comment="10Mbps download type"
add name=type-20m kind=pcq pcq-classifier=dst-address \
    comment="20Mbps download type"

# Step 2 — Simple Queues per subscriber plan
/queue simple

# Basic Plan — 5Mbps
add name="Basic-5M" \
    target=192.168.100.0/24 \
    max-limit=5M/5M \
    burst-limit=7M/7M \
    burst-threshold=4M/4M \
    burst-time=8s/8s \
    comment="Basic Plan — 5Mbps with burst"

# Standard Plan — 10Mbps
add name="Standard-10M" \
    target=192.168.101.0/24 \
    max-limit=10M/10M \
    burst-limit=15M/15M \
    burst-threshold=8M/8M \
    burst-time=8s/8s \
    comment="Standard Plan — 10Mbps with burst"

# Premium Plan — 20Mbps
add name="Premium-20M" \
    target=192.168.102.0/24 \
    max-limit=20M/20M \
    burst-limit=30M/30M \
    burst-threshold=15M/15M \
    burst-time=8s/8s \
    comment="Premium Plan — 20Mbps with burst"

# Business Plan — 50Mbps
add name="Business-50M" \
    target=192.168.103.0/24 \
    max-limit=50M/50M \
    priority=1 \
    comment="Business Plan — 50Mbps priority"

# Step 3 — Individual client queue example
/queue simple
add name="Client-Ahmed-10M" \
    target=192.168.100.10/32 \
    max-limit=10M/10M \
    burst-limit=15M/15M \
    burst-threshold=8M/8M \
    burst-time=8s/8s \
    comment="Ahmed — Standard 10Mbps"

add name="Client-Ali-5M" \
    target=192.168.100.11/32 \
    max-limit=5M/5M \
    comment="Ali — Basic 5Mbps"

# Step 4 — Global queue for total bandwidth control
/queue simple
add name="Total-Bandwidth" \
    target=0.0.0.0/0 \
    max-limit=100M/100M \
    comment="Total ISP bandwidth limit — adjust as needed"

# ============================================
# Verification Commands:
# /queue simple print
# /queue simple monitor 0
# ============================================
