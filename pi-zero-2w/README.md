# Raspberry Pi Zero 2W - Ubuntu Server 24.04 LTS Optimization

[한국어](README_KO.md) | **English**

Lightweight setup for Raspberry Pi Zero 2W with Ubuntu Server 24.04 LTS,<br/>
optimized for headless (SSH-only) server use by reducing memory and disabling unnecessary services.

## Optimization Results

| Item | Before | After |
|------|--------|-------|
| Total Memory | 409MB | 457MB (+48MB) |
| Memory Used | 163MB | 134MB |
| Available | 245MB | 322MB |
| Running Services | 21 | 13 |
| GPU Memory | 64MB | 16MB |
| Swap | None | 1GB |

## Prerequisites

- Raspberry Pi Zero 2W
- Ubuntu Server 24.04 LTS installed
- `sudo apt update && sudo apt upgrade -y` completed
- SSH access available

## Optimization Details

### 1. GPU Memory Reduction (64MB → 16MB)
No display is used, so GPU memory is reduced to the minimum (16MB) to free up system memory.

### 2. Create 1GB Swap
Physical memory is limited to 512MB, so a 1GB swap file is created.<br/>
`swappiness=10` is set to prioritize RAM usage.

### 3. Disable Unnecessary Services
Disable services not needed on a headless server.

| Service | Reason |
|---------|--------|
| snapd | Snap not used, high memory consumption |
| ModemManager | No modem (unrelated to Wi-Fi) |
| udisks2 | USB auto-mount, unnecessary for server |
| unattended-upgrades | Auto-upgrade, unnecessary for manual management |
| serial-getty@ttyS0 | Serial console login, unnecessary with SSH only |

### 4. Disable Bluetooth
Bluetooth is not used, so it is disabled at the hardware level.

## Usage

### Apply Optimization
```bash
chmod +x optimize.sh
sudo ./optimize.sh
sudo reboot
```

### Rollback Optimization
```bash
chmod +x rollback.sh
sudo ./rollback.sh
sudo reboot
```

### Verify
```bash
free -h
vcgencmd get_mem gpu
systemctl list-units --type=service --state=running --no-pager
```

## Files

| File | Description |
|------|-------------|
| `README.md` | This document |
| `optimize.sh` | Optimization apply script |
| `rollback.sh` | Optimization rollback script |

## Notes

- If SSH becomes inaccessible, remove the SD card and restore symlinks from another Linux machine
- Minimum `gpu_mem` value is 16MB (Raspberry Pi hardware limit)
- GPU memory and Bluetooth setting changes take effect after reboot

## Troubleshooting

### SSH Connection Failure (ThinkCentre M75q Tiny Gen 5 / Windows 11 / Wi-Fi)

If SSH connection fails from a ThinkCentre M75q Tiny Gen 5 with only Wi-Fi connected,<br/>
toggling Wi-Fi off and on in Windows Settings resolves the issue.<br/>
SSH works fine from other Linux machines, so this is likely a Windows Wi-Fi adapter issue.
