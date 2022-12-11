#!/usr/bin/env bash

# https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault

TMP_DIR="/app/tmp"
TMP_DATA_DIR="${TMP_DIR}/data"
mkdir -p ${TMP_DATA_DIR}

echo -e "Run backup..."

# Create backup filename.
BACKUP_FILE="backup_$(date '+%Y-%m-%d_%H-%M-%S')"
#echo -e "${BACKUP_FILE}"

# Use sqlite3 to create backup (avoids corruption if db write in progress).
sqlite3 /bitwarden/db.sqlite3 ".backup '${TMP_DATA_DIR}/db.sqlite3'"
# Backup other stuff.
cp -r /bitwarden/attachments ${TMP_DATA_DIR}/attachments
cp /bitwarden/config.json ${TMP_DATA_DIR}/
cp /bitwarden/rsa_key* ${TMP_DATA_DIR}/
#ls -l ${TMP_DIR}

# Tar up backup and encrypt with openssl and encryption key.
tar -czf "${TMP_DIR}/${BACKUP_FILE}.tar.gz" -C ${TMP_DATA_DIR} .
openssl enc -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -in "${TMP_DIR}/${BACKUP_FILE}.tar.gz" -out "${TMP_DIR}/${BACKUP_FILE}.tar.gz.enc"
#ls -l ${TMP_DIR}

# Upload encrypted tar to Google drive.
python3 /app/upload.py --upload-file --file-name "${BACKUP_FILE}.tar.gz.enc" --file-path "${TMP_DIR}/${BACKUP_FILE}.tar.gz.enc" --mime-type "application/x-tar"

# Cleanup tmp folder.
rm -rf /app/tmp/*

echo -e "Backup done."
