#!/bin/bash
# Raspberry Pi Zero 2W - Ubuntu Server 24.04 LTS 최적화 스크립트
# 사전 조건: apt update && apt upgrade 완료 상태에서 실행
set -e

echo "=========================================="
echo " Raspberry Pi Zero 2W 최적화 시작"
echo "=========================================="

# 1. GPU 메모리 축소 (64 → 16MB)
echo ""
echo "[1/4] GPU 메모리 축소 (64 → 16MB)..."
if grep -q '^gpu_mem=' /boot/firmware/config.txt; then
    sudo sed -i 's/^gpu_mem=.*/gpu_mem=16/' /boot/firmware/config.txt
else
    echo 'gpu_mem=16' | sudo tee -a /boot/firmware/config.txt > /dev/null
fi
echo "  완료 (재부팅 후 적용)"

# 2. Swap 1GB 생성 + swappiness=10
echo ""
echo "[2/4] Swap 1GB 생성..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile > /dev/null
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
    echo "  스왑 파일 생성 완료"
else
    echo "  스왑 파일이 이미 존재합니다. 건너뜁니다."
fi
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf > /dev/null
sudo sysctl vm.swappiness=10 > /dev/null
echo "  swappiness=10 설정 완료"

# 3. 불필요한 서비스 비활성화
echo ""
echo "[3/4] 불필요한 서비스 비활성화..."

disable_service() {
    if systemctl list-unit-files "$1" &>/dev/null; then
        sudo systemctl disable --now "$1" 2>/dev/null && echo "  - $1 비활성화 완료" || echo "  - $1 비활성화 실패 (이미 비활성화되었거나 존재하지 않음)"
    else
        echo "  - $1 없음, 건너뜁니다."
    fi
}

disable_service snapd.service
disable_service snapd.socket
disable_service snapd.seeded.service
disable_service ModemManager.service
disable_service udisks2.service
disable_service unattended-upgrades.service
disable_service serial-getty@ttyS0.service

# 4. 블루투스 비활성화 (하드웨어 레벨)
echo ""
echo "[4/4] 블루투스 비활성화..."
if ! grep -q '^dtoverlay=disable-bt' /boot/firmware/config.txt; then
    echo 'dtoverlay=disable-bt' | sudo tee -a /boot/firmware/config.txt > /dev/null
    echo "  완료 (재부팅 후 적용)"
else
    echo "  이미 설정되어 있습니다. 건너뜁니다."
fi

# 결과 출력
echo ""
echo "=========================================="
echo " 최적화 완료"
echo "=========================================="
echo ""
echo "[현재 메모리 상태]"
free -h
echo ""
echo "[현재 swappiness]"
cat /proc/sys/vm/swappiness
echo ""
echo "※ GPU 메모리, 블루투스 설정은 재부팅 후 적용됩니다."
echo "  재부팅: sudo reboot"
