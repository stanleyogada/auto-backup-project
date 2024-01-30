#!/bin/bash

file_or_dir_to_backup="$1";

if [[ -z $file_or_dir_to_backup ]]; then
	echo "Provide the path to the backup directoy";
	echo "Usage: $0 /path-to-backup";
	exit 1;
fi;

if [[ ! -e /usr/local/bin/daily.backup.sh ]]; then
	sudo cp ./daily.backup.sh /usr/local/bin/;
	sudo chmod 777 $(which daily.backup.sh); 
fi;

has_daily_cron="$(crontab -l | grep daily)";

if [[ -z $has_daily_cron ]]; then
	echo -e "$(crontab -l)\n0 2 * * * daily.backup.sh $file_or_dir_to_backup" | crontab -;
	echo "A daily backup of $file_or_dir_to_backup will commence by 02:00 PM"
else
	echo "Already has a daily cron running already!"
	echo "You might need to add the cron manually!"
fi;

exit 0;
