#!/bin/bash
# Raspberry Pi Zero 2W - 최적화 롤백 스크립트
# 모든 최적화 설정을 원래 상태로 되돌립니다.
set -e

echo "=========================================="
echo " Raspberry Pi Zero 2W 최적화 롤백 시작"
echo "=========================================="

# 1. GPU 메모리 설정 제거
echo ""
echo "[1/4] GPU 메모리 설정 제거..."
sudo sed -i '/^gpu_mem=16$/d' /boot/firmware/config.txt
echo "  완료 (재부팅 후 적용)"

# 2. Swap 제거
echo ""
echo "[2/4] Swap 제거..."
if [ -f /swapfile ]; then
    sudo swapoff /swapfile 2>/dev/null || true
    sudo rm /swapfile
    sudo sed -i '\|^/swapfile|d' /etc/fstab
    echo "  스왑 파일 제거 완료"
else
    echo "  스왑 파일이 없습니다. 건너뜁니다."
fi
if [ -f /etc/sysctl.d/99-swappiness.conf ]; then
    sudo rm /etc/sysctl.d/99-swappiness.conf
fi
sudo sysctl vm.swappiness=60 > /dev/null
echo "  swappiness=60 (기본값) 복원 완료"

# 3. 서비스 재활성화
echo ""
echo "[3/4] 서비스 재활성화..."

enable_service() {
    sudo systemctl enable --now "$1" 2>/dev/null && echo "  - $1 활성화 완료" || echo "  - $1 활성화 실패 (존재하지 않음)"
}

enable_service snapd.service
enable_service snapd.socket
enable_service snapd.seeded.service
enable_service ModemManager.service
enable_service udisks2.service
enable_service unattended-upgrades.service
enable_service serial-getty@ttyS0.service

# 4. 블루투스 설정 제거
echo ""
echo "[4/4] 블루투스 설정 제거..."
sudo sed -i '/^dtoverlay=disable-bt$/d' /boot/firmware/config.txt
echo "  완료 (재부팅 후 적용)"

# 결과 출력
echo ""
echo "=========================================="
echo " 롤백 완료"
echo "=========================================="
echo ""
echo "[현재 메모리 상태]"
free -h
echo ""
echo "※ GPU 메모리, 블루투스 설정은 재부팅 후 적용됩니다."
echo "  재부팅: sudo reboot"
