## Server Overview

This Server is used by CloudByte and it's workers. Over the time we added serveral Scripts, which you find under Scripts-Section to maintain reliability, usability and automate processes.
The data is stored under /shared in which every team has ts's own folders to work and create files. We do have a Dropbox folder, which has restricted access. Just owners of the file are able to access their files there.

## Scripts

The following scripts help and support us in our daily routine

scripts/
backup-shared.sh	this is to backup all the data from the shared-folder
cleanup-backups.sh	is used to cleanup after 7 days or more, so we don't use much of our capacity for backup-storing
restore-backup.sh	is used for restoring backups, if things goes sideways
onboard-user.sh		is used to automate onboarding

## Scheduled jobs

The following scripts are opperated automaticaly by crontab: backup-shared.sh and clean-up.sh 

## Users and groups

CloudByte runs with twelve staff across three teams: Engineering, Marketing, and Operations. Each team has its own group, and two Operations staff also sit in the `admins` group for sysadmin work. Every user has a standard home directory and a shell login.

| Username | Full name | Group(s) | Department |
|---|---|---|---|
| alice | Alice Tan | engineering | Engineering |
| bob | Bob Patel | engineering | Engineering |
| carol | Carol O'Sullivan | engineering | Engineering |
| dave | Dave Yamamoto | engineering | Engineering |
| emma | Emma Kowalski | marketing | Marketing |
| frank | Frank Nguyen | marketing | Marketing |
| grace | Grace Okafor | marketing | Marketing |
| henry | Henry Mendez | operations | Operations |
| iris | Iris Brennan | operations | Operations |
| jack | Jack Hossain | operations | Operations |
| kate | Kate Reilly | operations, admins | Operations |
| leo | Leo Costa | operations, admins | Operations |

| Group | Members | Access |
|---|---|---|
| engineering | alice, bob, carol, dave | Read/write to `/shared/engineering` |
| marketing | emma, frank, grace | Read/write to `/shared/marketing` |
| operations | henry, iris, jack, kate, leo | Read/write to `/shared/operations` |
| admins | kate, leo | Write to `/shared/company-docs` and `/logs/reports`; read dropbox submissions |

Admins post to the company notice board and reports directories and triage the dropbox; team members write only to their own folder. Least-privilege as usual.

## Self-Checks

For all available scripts we have verifing scripts to check if the scripts are doing what they supposted to do. 
