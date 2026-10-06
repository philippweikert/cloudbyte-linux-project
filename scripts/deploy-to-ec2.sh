#!/bin/bash
# deploy-to-ec2.sh: CloudByte Solutions folder and file deployment automation
# Author: Philipp Weikert
# Created: 2026-10-06
# Purpose: Automate the creation of a new folder-structure and copiing files to a new cloudbyte-server.
# Usage: sudo bash ~/../cloud-course/linux-project/scripts/deploy-to-ec2.sh

set -eo pipefail

# --- Sudo guard -----------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "Error: backup-shared.sh must be run as root."
    echo "Hint: sudo bash $0"
    exit 1
fi

# --- Config ---------------------------------------------------------------

DRY_RUN=false
PATH1="ssh cloudbyte-ec2 /shared/*"
PATH2="ssh cloudbyte-ec2 /logs/*"
PATH3="ssh cloudbyte-ec2 ~/cloud-course/*"

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
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

# --- Creating function ---------------------------------------------------------------

create_path() {

    if [ "$DRY_RUN" = true ]; then
        echo "[dry-run] would create $PATH1 and $PATH2"
        return 0
    fi
   
    if [[ -e "PATH1" && -e "PATH2" ]]; then
	echo "Both paths already exists!"
	return 0
    else
	ssh cloudbyte-ec2 'mkdir -p /shared/engineering /shared/marketing /shared/operations \
              /shared/company-docs /shared/backups /logs/reports'
	echo "Folders have been created!" 
    fi
}

create_path

# --- Creating function ---------------------------------------------------------------

copy_files() {

    if [ "$DRY_RUN" = true ]; then
        echo "[dry-run] would copy the files and folders"
        return 0
    fi

    scp -r scripts cloudbyte-ec2:~/cloud-course/linux-project/
    scp -r data cloudbyte-ec2:~/cloud-course/linux-project/
    scp cloudbyte-ec2:~/verify-ec2.sh

    if [ -e "PATH3" = true ]; then
	echo "Scripts and data are successful copied"
    else
        echo "There was a problem"
    fi
}

copy_files
