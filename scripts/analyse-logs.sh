#!/bin/bash/

set -eo pipefail

# --- Sudo guard -----------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "Error: backup-shared.sh must be run as root."
    echo "Hint: sudo bash $0"
    exit 1
fi

SEVERE_COUNT="$(awk '{ print $3 }' /logs/cloudbyte-app.log | sort | uniq -c | sort -rn)"
BUSY_COUNT="$(awk '{ print $2 }' /logs/cloudbyte-app.log | cut -c1-2 | sort | uniq -c | sort -rn)"
CRITICAL_COUNT="$(awk '{ print $3 }' /logs/cloudbyte-app.log | sort | uniq -c | sort -rn | grep '\[CRITICAL\]' || echo "(none)")"

echo "Count of different tiers of alerting"
echo $SEVERE_COUNT
echo "Hours of the alerts"
echo $BUSY_COUNT
echo "Numbers of CRITICAL-Alerts"
echo $CRITICAL_COUNT


