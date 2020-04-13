#!/usr/bin/env bash

TMP_DIR="/app/tmp"

echo -e "Run backup..."

# Create backup filename.
BACKUP_FILE="db.sqlite3_$(date '+%Y-%m-%d_%H-%M-%S')"

# Use sqlite3 to create backup (avoids corruption if db write in progress).
sqlite3 /bitwarden/db.sqlite3 ".backup '${TMP_DIR}/db.sqlite3'"

# Tar up backup and encrypt with openssl and encryption key.
tar -czf - ${TMP_DIR}/db.sqlite3 | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out "${TMP_DIR}/${BACKUP_FILE}.tar.gz"

# Upload encrypted tar to Google drive.
python3 /app/upload.py --upload-file --file-name "${BACKUP_FILE}.tar.gz" --file-path "${TMP_DIR}/${BACKUP_FILE}.tar.gz" --mime-type "application/tar+gzip"

# Cleanup tmp folder.
rm -rf /app/tmp/*

echo -e "Backup done."
