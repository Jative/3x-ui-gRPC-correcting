#!/bin/bash
# /usr/local/bin/xui-watchdog.sh
# x-ui gRPC memory leak watchdog
# https://github.com/YOUR_USERNAME/xui-grpc-watchdog

THRESHOLD=80  # RAM usage threshold in percent
LOG_FILE=/var/log/xui-watchdog.log

MEM_USED=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')

if [ "$MEM_USED" -gt "$THRESHOLD" ]; then
    echo "$(date): RAM ${MEM_USED}% > ${THRESHOLD}%, restarting x-ui" >> "$LOG_FILE"
    x-ui restart
fi
