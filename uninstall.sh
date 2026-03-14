#!/bin/bash
# uninstall.sh — xui-grpc-watchdog removal
set -e

echo "[*] Removing xui-grpc-watchdog..."

systemctl disable --now xui-watchdog.timer 2>/dev/null || true
systemctl disable --now xui-watchdog.service 2>/dev/null || true

rm -f /etc/systemd/system/xui-watchdog.timer
rm -f /etc/systemd/system/xui-watchdog.service
rm -f /usr/local/bin/xui-watchdog.sh

systemctl daemon-reload

echo "[✓] Removed. Log file preserved at /var/log/xui-watchdog.log"
