#!/bin/bash
# apt-get install pigz -yqq
# chmod a+x plexautobackup.sh 
# sudo sed -i '$a\@weekly bash /path/to/script/plexautobackup.sh\' /var/spool/cron/crontabs/root

# Automatic Backup Plex and sync to Google  Drive

# Variables
username=${username}
local_backup=/home/${username}/rclone/backup
remote=gdrive
remote_backup=backup

# Stop Plex
sudo systemctl stop plexmediaserver.service
sleep 2s

# Backup Plex database
tar cf - "/var/lib/plexmediaserver/" -P | pigz > "/home/bte/$(date +%F-%R)-PlexBackup.tar.gz" &
sleep 2s

# Restart Plex
sudo systemctl start plexmediaserver.service
sleep 2s

# Send backup to Google Drive
rclone --config "/home/${username}/.config/rclone/rclone.conf" move "$local_backup" "$remote:$remote_backup" --log-file=/home/"${username}"/rclone/move.log -v --user-agent user

# Remove local backup
rm -rv "$local_backup/*"