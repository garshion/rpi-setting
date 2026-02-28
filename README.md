# rpi-setting

[한국어](README_KO.md) | **English**

A collection of initial setup scripts for personal Raspberry Pi devices.<br/>
Organized for quick reuse when reinstalling the OS or setting up a new device.

## Directory Structure

```
rpi-setting/
└── pi-zero-2w/     # Raspberry Pi Zero 2W
```

## Device Setup

| Device | OS | Purpose | Description |
|--------|----|---------|-------------|
| [Pi Zero 2W](pi-zero-2w/) | Ubuntu Server 24.04 LTS | Headless Server | Lightweight optimization: GPU memory reduction, Swap creation, disable unnecessary services |

## Common Prerequisites

- OS installation and initial setup completed
- SSH access available
- `sudo apt update && sudo apt upgrade -y` completed

## License

[MIT License](LICENSE)
