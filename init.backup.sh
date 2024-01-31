#!/bin/bash

# Author: Stanley Ogada Chinedu
# Date Created: 29/01/2024
# Last Modified: 30/01/2024
#
# Description
# - This script adds all the backup scripts (daily, weekly, monthly) to the crontab. Hence eliminating the need for adding the backups scripts manually to the crontab.
# - All the compressions are stored in a backup dir in your HOME directory. (~/backups/)
# - Note: You must have SSH key setup on the remote host. Find the backup dir also in the Home directory of the remote user. (~/backups)
#
# Usage
# # (1) If you wish to backup one file for example /home/user/web-app is the file provide it as a string (between quotes) as the positional arguement number 1.
# ---
# ./init.backup.sh "/home/user/web-app" "user@198.168.1.0"
# ---
#
#
# (2) If you wish to backup multiple files same as the above step but add whitespaces as seperator still withing the string.
# ---
# ./init.backup.sh "/home/user/web-app /home/user/Videos /tmp/my-temp-files" "user@198.168.1.0"

# ---
#
#
# The positional arguement number 1 should be a string, and can have multiple path of directories of files to be backed up seperated by spaces.
#
# The positional arguement number 2 should be a string, and should the a remote host.


all_important_files_paths="$1";
remote_host="$2"
log_path="$HOME/.backups.logs";
mkdir -p $log_path;

# Terminate if $1 is not provided
if [[ -z $all_important_files_paths || -z $remote_host ]]; then
	echo "Provide the path to of all important file in a string and a remote host";
	echo "Usage: $0 \"/path-to-backup /another-important-file\" \"user@192.168.1.0\"";
	exit 1;
fi;
# Format: <script_type>/<cron_pattern>/<cron_summary>
#all_type=("daily/0 4 \* \* \*/4 AM every day", "weekly/0 2 \* \* 0/2 AM every Sunday", "monthly/0 0 1 \* \*/midnight on the 1st day of every month");
all_type=("daily/\* \* \* \* \*/4 AM every day");

for element in "${all_type[@]}"; do
	script_type="$(echo $element | cut -d "/" -f 1)";
	cron_pattern="$(echo $element | cut -d "/" -f 2)";
	cron_summary="$(echo $element | cut -d "/" -f 3)";

	# Remove the script from /usr/local/bin if it's there before
	if [[ -e "/usr/local/bin/$script_type.backup.sh" ]]; then
		sudo rm -f "/usr/local/bin/$script_type.backup.sh"; 
	fi;

	if [[ ! -e ./$script_type.backup.sh ]]; then
		echo "cd to the project's directory first. You can only run $0 from inside it parent directory";
		exit 1;
	fi;

	# Add the script to `/usr/local/bin` so the script can be execute with the full path
	sudo cp "./$script_type.backup.sh" /usr/local/bin/;
	sudo chmod 555 $(which "$script_type.backup.sh"); 

	# If no cronjob is found for each script, write the cron job to the crontab file 
	has_script_cron="$(crontab -l | grep $script_type)";
	if [[ -z $has_script_cron ]]; then
		echo -e "$(crontab -l)\n$(echo $cron_pattern | sed 's/\\//g') /usr/local/bin/$script_type.backup.sh \"$all_important_files_paths\" \"$remote_host\" >> $log_path/$script_type.cron.log 2>&1" | crontab -;

		echo "A $script_type backup of $all_important_files_paths will commence by $cron_summary"
	else
		echo "Already has a $script_type cron running already!"
		echo "You might need to edit the crontab manually using `crontab -e`"
	fi;
done;	

echo
echo "Find your local backups in $HOME/backups and the remote backups in $remote_host:~/backups"

exit 0;
