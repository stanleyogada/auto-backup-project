#!/bin/bash

# Author: Stanley Ogada Chinedu
# Date Created: 29/01/2024
# Last Modified: 30/01/2024
#
# Description
# - This script adds all the backup scripts (daily, weekly, monthly) to the crontab. Hence eliminating the need for adding the backups scripts manually to the crontab.
# - All the compressions are stored in a backup dir in your HOME directory. (~/backups/)
#
# Usage
# # (1) If you wish to backup one file for example /home/user/web-app is the file provide it as a string (between quotes) as the positional arguement number 1.
# ---
# ./init.backup.sh "/home/user/web-app"
# ---
#
#
# (2) If you wish to backup multiple files same as the above step but add whitespaces as seperator still withing the string.
# ---
# ./init.backup.sh "/home/user/web-app /home/user/Videos /tmp/my-temp-files"
# ---
#
#
# The positional arguement number 1 should be a string, and can multiple path of directories of files to be backed up seperated by spaces. 


file_or_dir_to_backup="$1";

# Terminate if $1 is not provided
if [[ -z $file_or_dir_to_backup ]]; then
	echo "Provide the path to the backup directoy";
	echo "Usage: $0 /path-to-backup";
	exit 1;
fi;

# Add the daily script to `/usr/local/bin` so the scrip can be execute with the full path
if [[ ! -e /usr/local/bin/daily.backup.sh ]]; then
	sudo cp ./daily.backup.sh /usr/local/bin/;
	sudo chmod 777 $(which daily.backup.sh); 
fi;

# If no cronjob is found, write the cron job to the crontab file with daily (02:00 AM)
has_daily_cron="$(crontab -l | grep daily)";
if [[ -z $has_daily_cron ]]; then
	echo -e "$(crontab -l)\n0 2 * * * daily.backup.sh $file_or_dir_to_backup" | crontab -;
	echo "A daily backup of $file_or_dir_to_backup will commence by 02:00 AM"
else
	echo "Already has a daily cron running already!"
	echo "You might need to add the cron manually!"
fi;

exit 0;
