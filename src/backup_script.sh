#!/bin/bash
date=$(date +%Y-%m-%d)
filename="backups/backup${date}.sql"
touch "${filename}"
pg_dump projektBDS > "${filename}"


