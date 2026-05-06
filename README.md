# 🔧 MikroTik Scripts

> Collection of MikroTik RouterOS automation scripts for ISP and network engineers.

[![MikroTik](https://img.shields.io/badge/MikroTik-MTCNA%20Certified-blue)](https://mikrotik.com)
[![RouterOS](https://img.shields.io/badge/RouterOS-v7.x-orange)](https://mikrotik.com/software)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Zilleali/Mikrotik-Scripts)](https://github.com/Zilleali/Mikrotik-Scripts/stargazers)

---

## 👨‍💻 About the Author

**Zill E Ali** — MTCNA Certified Network Engineer & ISP Specialist

- 🌐 Website: [zilleali.com](https://zilleali.com)
- 💼 LinkedIn: [linkedin.com/in/zilleali12](https://linkedin.com/in/zilleali12)
- 🛒 Fiverr: [fiverr.com/zillealibutt](https://fiverr.com/zillealibutt)
- 📧 Email: info@zilleali.com

> Currently managing FTTH and B2B/B2C ISP infrastructure at FiberX Digital,  
> serving 1,250+ clients across 28 sites with 99.99% uptime.

---

## 📁 Repository Structure

```
Mikrotik-Scripts/
├── firewall/
│   ├── basic-firewall-rules.rsc
│   ├── ddos-protection.rsc
│   └── port-scanner-block.rsc
├── pppoe/
│   ├── pppoe-server-setup.rsc
│   └── pppoe-client-monitor.rsc
├── hotspot/
│   ├── hotspot-setup.rsc
│   └── user-manager-config.rsc
├── bandwidth/
│   ├── pcq-queue-setup.rsc
│   └── simple-queue-isp.rsc
├── monitoring/
│   ├── snmp-setup.rsc
│   └── email-alerts.rsc
├── vpn/
│   ├── wireguard-setup.rsc
│   └── l2tp-server.rsc
└── utils/
    ├── backup-script.rsc
    └── ip-blacklist.rsc
```

---

## 🚀 Scripts Overview

### 🔥 Firewall
| Script | Description |
|--------|-------------|
| `basic-firewall-rules.rsc` | Essential firewall rules for MikroTik routers |
| `ddos-protection.rsc` | DDoS protection using address lists |
| `port-scanner-block.rsc` | Block port scanners automatically |

### 📡 PPPoE
| Script | Description |
|--------|-------------|
| `pppoe-server-setup.rsc` | Complete PPPoE server configuration for ISPs |
| `pppoe-client-monitor.rsc` | Monitor and auto-reconnect PPPoE clients |

### 🌐 Hotspot
| Script | Description |
|--------|-------------|
| `hotspot-setup.rsc` | Full hotspot setup with login page |
| `user-manager-config.rsc` | User Manager with data limits and speed profiles |

### 📊 Bandwidth Management
| Script | Description |
|--------|-------------|
| `pcq-queue-setup.rsc` | PCQ queuing for fair bandwidth distribution |
| `simple-queue-isp.rsc` | Simple queue setup for ISP clients |

### 📈 Monitoring
| Script | Description |
|--------|-------------|
| `snmp-setup.rsc` | SNMP configuration for LibreNMS/Zabbix |
| `email-alerts.rsc` | Email notifications for link down/up events |

### 🔒 VPN
| Script | Description |
|--------|-------------|
| `wireguard-setup.rsc` | WireGuard VPN server setup |
| `l2tp-server.rsc` | L2TP/IPSec VPN server configuration |

### 🛠️ Utilities
| Script | Description |
|--------|-------------|
| `backup-script.rsc` | Automated backup with email delivery |
| `ip-blacklist.rsc` | Dynamic IP blacklist management |

---

## ⚡ Quick Start

### How to use these scripts:

**Method 1 — Winbox Terminal:**
```bash
# Open Winbox → New Terminal
# Copy and paste script content
```

**Method 2 — SSH:**
```bash
ssh admin@192.168.1.1
# Paste script in terminal
```

**Method 3 — Import file:**
```bash
# Upload .rsc file to MikroTik Files
/import file=script-name.rsc
```

---

## 📋 Requirements

- MikroTik RouterOS **v6.x or v7.x**
- Admin access to router
- Basic RouterOS knowledge

---

## ⚠️ Disclaimer

- Always **test scripts in a lab environment** before applying to production
- Take a **backup before** applying any script: `/system backup save`
- Some scripts may need modification based on your network topology

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Submit issues for bugs or improvements
- Fork and create pull requests
- Star ⭐ the repo if you find it useful

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🔗 Related Projects

- **[NexaLink](https://zilleali.com/nexalink)** — Multi-tenant ISP Management SaaS Platform
- **[CCNA Labs](https://github.com/Zilleali)** — Cisco Packet Tracer lab files

---

> 💬 Need help with MikroTik? 
> [Hire me on Fiverr](https://fiverr.com/zillealibutt) or [contact me](https://zilleali.com/contact)
