#!/bin/bash

# Author: Stanley Ogada Chinedu
# Date Created: 29/01/2024
# Last Modified: 30/01/2024
#
#
# Description
# - Performs a daily backup of the provided important file/s.
# - Compresses with today's date, the important file/s with gzip + tar programs.
# - All the compressions are stored in a backup dir in your HOME directory. (~/backups/daily/)
# - Note: You must have SSH key setup on the remote host. Find the backup dir also in the Home directory of the remote user. (~/backups)
#
# Usage
# (1) If you wish to backup one file for example /home/user/web-app is the file provide it as a string (between quotes) as the positional arguement number 1.
# ---
# ./daily.backup.sh "/home/user/web-app" "user@198.168.1.0"
# ---
#
# (2) If you wish to backup multiple files same as the above step but add whitespaces as seperator still withing the string.
# ---
# ./daily.backup.sh "/home/user/web-app /home/user/Videos /tmp/my-temp-files" "user@198.168.1.0"
# ---

all_important_files_paths="$1";
remote_destination="$2"

# Loops through the important files paths and do for each important file, create its own directory in the backup directory and save the compression there
for important_file_path in $(echo "$all_important_files_paths"); do
	important_file_name="$(basename $important_file_path)";
	compressed_important_file_name="$important_file_name-$(date +%d-%m-%Y).tar.gz";
	backup_path="$HOME/backups/$important_file_name/daily";

	mkdir -p $backup_path;

	tar \
	-czf "$backup_path/$compressed_important_file_name" \
	--absolute-name "$important_file_path"\
	&> /dev/null; # Discard any error of output provided from tar program 

	# Remove the currupt tar file created if an error occured during the compression
	if [[ ! $? -eq 0 ]]; then
		find "$backup_path" -name "$compressed_important_file_name" -delete;
	fi
done;

declare -r BACKUP_PATH="$HOME/backups";

# Remove all backup files older than 7 days
find "$BACKUP_PATH" -mtime +7 -type f -delete;

# Synchronize local backup with the remote destination backup
rsync --delete -a --mkpath "$BACKUP_PATH/" "$remote_destination:~/backups/";
