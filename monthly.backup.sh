#!/bin/bash

# Author: Stanley Ogada Chinedu
# Date Created: 31/01/2024
# Last Modified: 01/02/2024
#
#
# Description
# - Performs a monthly backup of the provided important file/s.
#
# Usage
# See the usage for ./daily.backup.sh


all_important_files_paths="$1";
remote_destination="$2";
ssh_private_key="$3";

echo
echo "A monthly cron backup started($(date +%c))";
# Loops through the important files paths and do for each important file, create its own directory in the backup directory and save the compression there
for important_file_path in $(echo "$all_important_files_paths"); do
	important_file_name="$(basename $important_file_path)";
	compressed_important_file_name="$important_file_name-$(date +%d-%m-%Y).tar.gz";
	backup_path="$HOME/.backups/$important_file_name/monthly";

	mkdir -p $backup_path;
	echo "" 
	tar \
	-cvvzf "$backup_path/$compressed_important_file_name" \
	--absolute-name "$important_file_path";

	# Remove the currupt tar file created if an error occured during the compression
	if [[ ! $? -eq 0 ]]; then
		echo "Commpression of $important_file_path FAILED!"
	else
		echo "Commpression of $important_file_path SUCCESS!"
	fi
done;

declare -r BACKUP_PATH="$HOME/.backups";

# Remove all backup files older than 365 days
find "$BACKUP_PATH" -mtime +365 -type f -delete;
echo
# Synchronize local backup with the remote destination backup
/usr/bin/rsync --delete -avv --mkpath -e "ssh -i $ssh_private_key" "$BACKUP_PATH/" "$remote_destination:~/.backups/";
echo
echo "A monthly cron backup ended ($(date +%c))";
echo
