#!/usr/bin/env bash

# Run backup once on container start to ensure it works.
/app/./backup.sh

# Initialize cron
echo "Running as $(id)"
if [ "$(id -u)" -eq 0 ] && [ "$(grep -c "$BACKUP_CMD" "$CRONFILE")" -eq 0 ]; then
  echo "Initalizing..."
  echo "$CRON_TIME $BACKUP_CMD >> $LOGFILE 2>&1" | crontab -

fi

# Start crond if it's not running
pgrep crond > /dev/null 2>&1
if [ $? -ne 0 ]; then
  /usr/sbin/crond -L /app/log/cron.log
fi

echo "$(date "+%F %T") - Container started" > "$LOGFILE"
tail -F "$LOGFILE" /app/log/cron.log
