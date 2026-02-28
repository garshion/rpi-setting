# rpi-setting

개인 Raspberry Pi 장비들의 초기 세팅 스크립트 모음.<br/>
OS 재설치나 새 장비 세팅 시 바로 꺼내 쓸 수 있도록 정리한 저장소.

## 디렉토리 구조

```
rpi-setting/
└── pi-zero-2w/     # Raspberry Pi Zero 2W
```

## 장비별 세팅

| 장비 | OS | 용도 | 설명 |
|------|----|------|------|
| [Pi Zero 2W](pi-zero-2w/) | Ubuntu Server 24.04 LTS | 헤드리스 서버 | GPU 메모리 축소, Swap 생성, 불필요 서비스 비활성화 등 경량화 |

## 공통 사전 조건

- OS 설치 및 초기 설정 완료
- SSH 접속 가능한 상태
- `sudo apt update && sudo apt upgrade -y` 완료

## 라이선스

[MIT License](LICENSE)
