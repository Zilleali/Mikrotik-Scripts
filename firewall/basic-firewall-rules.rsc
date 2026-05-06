# MikroTik Basic Firewall Rules
# Author: Zill E Ali — MTCNA Certified
# Website: zilleali.com
# Version: 1.0
# RouterOS: v6.x / v7.x
#
# DISCLAIMER: Test in lab before production use
# Always backup first: /system backup save

/ip firewall filter

# --- INPUT CHAIN ---
# Allow established/related connections
add chain=input connection-state=established,related action=accept comment="Allow established"

# Drop invalid connections
add chain=input connection-state=invalid action=drop comment="Drop invalid"

# Allow ICMP (ping)
add chain=input protocol=icmp action=accept comment="Allow ICMP"

# Allow Winbox
add chain=input protocol=tcp dst-port=8291 action=accept comment="Allow Winbox"

# Allow SSH (change port for security)
add chain=input protocol=tcp dst-port=22 action=accept comment="Allow SSH"

# Drop everything else to router
add chain=input action=drop comment="Drop all other input"

# --- FORWARD CHAIN ---
# Allow established/related
add chain=forward connection-state=established,related action=accept comment="Allow established forward"

# Drop invalid
add chain=forward connection-state=invalid action=drop comment="Drop invalid forward"

# Allow LAN to internet
add chain=forward in-interface=bridge out-interface=ether1 action=accept comment="LAN to WAN"

# Drop everything else
add chain=forward action=drop comment="Drop all other forward"

# --- NAT ---
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade comment="NAT masquerade"