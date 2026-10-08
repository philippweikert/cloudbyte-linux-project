#!/bin/bash
# system-health.sh: snapshot CloudByte server health into a timestamped report.
# Author:  <your name>
# Created: <date>
# Purpose: Capture uptime/load, memory, disk, the top processes, service status,
#          and logged-in users; format with printf; write to /logs/health-reports/
#          and print it. (Alerts and archiving added in later steps.)
# Usage:   sudo bash system-health.sh

set -eo pipefail

# --- Sudo guard -----------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "Error: system-health.sh must be run as root (it writes to /logs)."
    echo "Hint: sudo bash $0"
    exit 1
fi

# --- Config ---------------------------------------------------------------
REPORT_DIR=/logs/health-reports
ARCHIVE_DIR="$REPORT_DIR/archive"
mkdir -p "$ARCHIVE_DIR"
REPORT="$REPORT_DIR/health-$(date +%F-%H%M%S).txt"
SERVICES="crond sshd"
DISK_THRESHOLD=80
disk_use=$(df --output=pcent / | tail -1 | tr -d ' %')
zombies=$(ps -eo stat= | grep -c '^Z' || true)
alert_count=0

{
printf '\n'
printf "=== CloudByte system health: $(date) === %s\n"
printf '\n'
printf "Host: %s\n" "$(hostname)"
printf '\n'
printf '%s\n' "--- Uptime and load ---"
	uptime
printf '\n'
printf '%s\n' "--- Memory ---"
	free -h
printf '\n'
printf '%s\n' "--- Disk ---"
	df -h
printf '\n'
printf '%s\n' "--- Top processes by CPU ---"
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
printf '\n'
printf '%s\n' "--- Services ---"
    for svc in $SERVICES; do
        printf '%-12s %s\n' "$svc" "$(systemctl is-active "$svc")"
    done
printf '\n'
printf '%s\n' "--- Logged-in users ---"
who
printf '\n'
printf '%s\n' "--- Alerts ---"
if [ "$disk_use" -gt "$DISK_THRESHOLD" ]; then
     printf 'ALERT: disk usage is %s%% (threshold: %s%%)\n' \
        "$disk_use" "$DISK_THRESHOLD"
     alert_count=$((alert_count + 1))
fi

if [ "$zombies" -gt 0 ]; then
      printf 'ALERT: found %s zombie process(es)\n' \
        "$zombies"
      alert_count=$((alert_count + 1))
fi

for svc in $SERVICES; do
    if ! systemctl is-active --quiet "$svc"; then
        printf 'ALERT: service %s is not active\n' "$svc"
        alert_count=$((alert_count + 1))
    fi
done

if [ "$alert_count" -eq 0 ]; then
    echo "No alerts. All checks within thresholds."
fi
} | tee "$REPORT"

#--- Archive reports older than a week ------------------------------------
find "$REPORT_DIR" -maxdepth 1 -name 'health-*.txt' -mtime +7 -exec mv {} "$ARCHIVE_DIR"/ \;
