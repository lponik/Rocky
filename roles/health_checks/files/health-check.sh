#!/bin/bash

echo "=== Server Health Check ==="
echo "Time: $(date)"

echo
echo "Nginx:"
if systemctl is-active --quiet nginx; then
    echo "Nginx: OK"
else
    echo "Nginx: FAILED"
fi

echo
echo "HTTP Health"
if curl -fs http://localhost/health > /dev/null; then
    echo "HTTP Health: OK"
else
    echo "HTTP Health: FAILED"
fi

echo
echo "Disk Usage:"
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo "Disk Usage: OK ($DISK_USAGE%)"
else
    echo "Disk Usage: WARNING ($DISK_USAGE%)"
fi

echo
echo "Memory:"
MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
if [ "$MEM_USAGE" -lt 80 ]; then
    echo "Memory Usage: OK ($MEM_USAGE%)"
else
    echo "Memory Usage: WARNING ($MEM_USAGE%)"
fi
