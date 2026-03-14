#!/bin/bash
# install.sh — xui-grpc-watchdog installer
set -e

echo "[*] Installing xui-grpc-watchdog..."

# Copy watchdog script
cp scripts/xui-watchdog.sh /usr/local/bin/xui-watchdog.sh
chmod +x /usr/local/bin/xui-watchdog.sh

# Copy systemd units
cp systemd/xui-watchdog.timer /etc/systemd/system/xui-watchdog.timer
cp systemd/xui-watchdog.service /etc/systemd/system/xui-watchdog.service

# Enable and start
systemctl daemon-reload
systemctl enable --now xui-watchdog.timer

echo "[✓] Done. Timer status:"
systemctl status xui-watchdog.timer --no-pager
