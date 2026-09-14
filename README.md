# Moto G5 Home Lab: AdGuard + Tailscale + Kernel Battery Management

This repository contains the orchestration scripts for a repurposed, rooted Moto G5 serving as a 24/7 network-wide DNS filter and VPN gateway.

## 🚀 Overview

A low-power home server solution built inside Termux, featuring automated startup, remote mesh networking, and hardware-level battery protection.

### Core Services

* **AdGuard Home:** DNS-based ad and tracker blocking.
* **Tailscale:** Private mesh VPN for secure remote access.
* **Battery Watchdog:** A kernel-direct monitor for managing device longevity.

---

## 🛠 Project Structure

* `start_server.sh`: Self-healing AdGuard Home process manager.
* `start_tailscale.sh`: Tailscale initialization with absolute path persistence.
* `battery_limit.sh`: **Kernel-direct** monitor that reads `/sys/class/power_supply/` to track battery health without relying on the unstable Android API.
* `start.sh`: The master orchestrator, located in `~/.termux/boot/`, which launches all services into a labeled `tmux` session at boot.

---

## 🔧 Installation & Deployment

### 📦 Manual Installation & Dependencies

If you are setting this up on a fresh device from scratch, the core binaries must be downloaded and positioned correctly within the Termux home directory before running the orchestrator.

### 1. Prerequisites

* Rooted Android device with Termux and Termux:Boot installed.
* Required packages:

```bash
pkg install git tmux tsu sudo termux-api
```

### 2. AdGuard Home Setup

AdGuard Home must be downloaded using the official Linux ARMv7 binary distribution:

```bash
# Download the official Linux ARMv7 release
curl -L -o AdGuardHome_linux_armv7.tar.gz https://static.adguard.com/adguardhome/release/AdGuardHome_linux_armv7.tar.gz

# Extract the archive
tar -xvzf AdGuardHome_linux_armv7.tar.gz

# Verify the binary execution path exists
cd ~/AdGuardHome
./AdGuardHome --version
```

### 3. Tailscale Setup

Since Android standard packages do not provide native CLI routing inside Termux, Tailscale must be run using static binaries via user-space networking.

Download the static ARM archive:

```bash
curl -L -o tailscale_1.96.4_arm.tgz https://pkgs.tailscale.com/stable/tailscale_1.96.4_arm.tgz
```

Extract and isolate the `tailscale` and `tailscaled` binaries:

```bash
tar -xvzf tailscale_1.96.4_arm.tgz
mv tailscale_1.96.4_arm ~/tailscale_bin
```

Add the binaries to the execution path:

```bash
export PATH="$HOME/tailscale_bin:$PATH"
```

### 4. Clone & Setup

```bash
git clone https://github.com/kunjjavia/DNS-Sinkhole-AD-Blocker.git
cd DNS-Sinkhole-AD-Blocker
chmod +x *.sh
```
