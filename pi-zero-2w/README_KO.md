# Raspberry Pi Zero 2W - Ubuntu Server 24.04 LTS 최적화

**한국어** | [English](README.md)

Raspberry Pi Zero 2W에 Ubuntu Server 24.04 LTS를 설치한 뒤,<br/>
헤드리스(SSH 전용) 서버 용도에 맞게 메모리 및 서비스를 경량화하는 세팅.

## 최적화 결과

| 항목 | 최적화 전 | 최적화 후 |
|------|-----------|-----------|
| 전체 메모리 | 409MB | 457MB (+48MB) |
| 메모리 사용 | 163MB | 134MB |
| 사용 가능 | 245MB | 322MB |
| 실행 서비스 | 21개 | 13개 |
| GPU 메모리 | 64MB | 16MB |
| Swap | 없음 | 1GB |

## 사전 조건

- Raspberry Pi Zero 2W
- Ubuntu Server 24.04 LTS 설치 완료
- `sudo apt update && sudo apt upgrade -y` 완료
- SSH 접속 가능한 상태

## 최적화 항목

### 1. GPU 메모리 축소 (64MB → 16MB)
디스플레이를 사용하지 않으므로 GPU 메모리를 최소값(16MB)으로 축소하여 시스템 메모리를 확보.

### 2. Swap 1GB 생성
물리 메모리가 512MB로 제한적이므로 1GB 스왑 파일을 생성.<br/>
`swappiness=10`으로 설정하여 가능한 한 RAM을 우선 사용.

### 3. 불필요한 서비스 비활성화
헤드리스 서버에서 사용하지 않는 서비스를 비활성화.

| 서비스 | 사유 |
|--------|------|
| snapd | snap 미사용, 메모리 소비 큼 |
| ModemManager | 모뎀 미사용 (Wi-Fi와 무관) |
| udisks2 | USB 자동마운트, 서버에서 불필요 |
| unattended-upgrades | 자동 업그레이드, 수동 관리 시 불필요 |
| serial-getty@ttyS0 | 시리얼 콘솔 로그인, SSH만 사용 시 불필요 |

### 4. 블루투스 비활성화
블루투스를 사용하지 않으므로 하드웨어 레벨에서 비활성화.

## 사용법

### 최적화 적용
```bash
chmod +x optimize.sh
sudo ./optimize.sh
sudo reboot
```

### 최적화 롤백
```bash
chmod +x rollback.sh
sudo ./rollback.sh
sudo reboot
```

### 적용 확인
```bash
free -h
vcgencmd get_mem gpu
systemctl list-units --type=service --state=running --no-pager
```

## 파일 구성

| 파일 | 설명 |
|------|------|
| `README.md` | 이 문서 |
| `optimize.sh` | 최적화 일괄 적용 스크립트 |
| `rollback.sh` | 최적화 일괄 롤백 스크립트 |

## 주의사항

- SSH 접속 불가 시 SD카드를 꺼내 다른 리눅스에서 심볼릭 링크를 복원해야 함
- `gpu_mem` 최소값은 16MB (라즈베리파이 하드웨어 제한)
- GPU 메모리, 블루투스 설정 변경은 재부팅 후 적용됨

## 트러블슈팅

### SSH 접속 불가 (ThinkCentre M75q Tiny Gen 5 / Windows 11 / Wi-Fi 환경)

ThinkCentre M75q Tiny Gen 5에서 Wi-Fi만 연결된 상태로 SSH 접속이 안 되는 경우,<br/>
Windows 설정에서 Wi-Fi를 껐다가 다시 켜면 해결됨.<br/>
다른 리눅스 장비에서는 정상적으로 접속되므로 Windows Wi-Fi 어댑터 측 문제로 추정.
