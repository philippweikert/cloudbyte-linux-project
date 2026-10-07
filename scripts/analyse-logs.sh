#!/bin/bash/
# Usage: sudo bash analyse-logs.sh

set -eo pipefail

# --- Sudo guard -----------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "Error: backup-shared.sh must be run as root."
    echo "Hint: sudo bash $0"
    exit 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --level)
            echo "$(awk '{ print $3 }' /logs/cloudbyte-app.log | sort | uniq -c | sort -rn | grep '\[ERROR\]' || echo "(none)")"
            shift 2
            ;;
        -h|--help)
            grep '^# Usage:' "$0" | sed 's/^# //'
            exit 0
            ;;
         *)
            echo "Error: unknown argument '$1'." >&2
            exit 1
	    ;;
    esac
done

SEVERE_COUNT="$(awk '{ print $3 }' /logs/cloudbyte-app.log | sort | uniq -c | sort -rn)"
BUSY_COUNT="$(awk '{ print $2 }' /logs/cloudbyte-app.log | cut -c1-2 | sort | uniq -c | sort -rn)"
CRITICAL_COUNT="$(awk '{ print $3 }' /logs/cloudbyte-app.log | sort | uniq -c | sort -rn | grep '\[CRITICAL\]' || echo "(none)")"

echo "Count of different tiers of alerting"
echo $SEVERE_COUNT
echo "Hours of the alerts"
echo $BUSY_COUNT
echo "Numbers of CRITICAL-Alerts"
echo $CRITICAL_COUNT


