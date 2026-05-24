# Moto G5 Home Lab: AdGuard + Tailscale + Kernel Battery Management

This repository contains the orchestration scripts for a repurposed, rooted Moto G5 serving as a 24/7 network-wide DNS filter and VPN gateway.

## 🚀 Overview
A low-power home server solution built inside Termux, featuring automated startup, remote mesh networking, and hardware-level battery protection.

### Core Services:
- **AdGuard Home:** DNS-based ad and tracker blocking.
- **Tailscale:** Private mesh VPN for secure remote access.
- **Battery Watchdog:** A kernel-direct monitor to manage device longevity.

---

## 🛠 Project Structure

- `start_server.sh`: Self-healing AdGuard Home process manager.
- `start_tailscale.sh`: Tailscale initialization with absolute path persistence.
- `battery_limit.sh`: **Kernel-Direct** monitor that reads `/sys/class/power_supply/` to track battery health without relying on the unstable Android API.
- `start.sh`: The master orchestrator (located in `~/.termux/boot/`) that launches all services into a labeled `tmux` session at boot.

---

## 🔧 Installation & Deployment

## 📦 Manual Installation & Dependencies

If you are setting this up on a fresh device from scratch, the core binaries must be downloaded and positioned correctly within the Termux home directory before running the orchestrator.

# 1. **Prerequisites:**
   - Rooted Android device with Termux & Termux:Boot installed.
   - `pkg install git tmux tsu sudo termux-api`

# 2. **AdGuard Home Setup**
AdGuard Home must be pulled down using the official Linux ARMv7 binary distribution:

```bash
# Download the official Linux ARMv7 release
curl -L -o AdGuardHome_linux_armv7.tar.gz [https://static.adguard.com/adguardhome/release/AdGuardHome_linux_armv7.tar.gz](https://static.adguard.com/adguardhome/release/AdGuardHome_linux_armv7.tar.gz)

# Extract the archive
tar -xvzf AdGuardHome_linux_armv7.tar.gz

# Verify the binary execution path exists
cd ~/AdGuardHome
./AdGuardHome --version
```
# 3. **Tailscale Setup**
Since Android standard packages won't allow native CLI routing inside Termux, Tailscale must be run using static binaries via user-space networking (TUN/TAP bypass):

Download the static compiled arm architecture archive
curl -L -o tailscale_1.96.4_arm.tgz [https://pkgs.tailscale.com/stable/tailscale_1.96.4_arm.tgz](https://pkgs.tailscale.com/stable/tailscale_1.96.4_arm.tgz)

Extract and isolate the tailscale/tailscaled binaries
tar -xvzf tailscale_1.96.4_arm.tgz
mv tailscale_1.96.4_arm ~/tailscale_bin

Add binaries to execution environment path
export PATH="$HOME/tailscale_bin:$PATH"

# 4. **Clone & Setup:**
   ```bash
   git clone [https://github.com/kunjjavia/DNS-Sinkhole-AD-Blocker.git](https://github.com/kunjjavia/DNS-Sinkhole-AD-Blocker.git)
   cd DNS-Sinkhole-AD-Blocker
   chmod +x *.sh
