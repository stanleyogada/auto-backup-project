#!/bin/bash

file_or_dir_to_backup_full_path="$1";
file_or_dir_to_backup_name="$(basename $1)";

backup_path="$HOME/backups/$file_or_dir_to_backup_name/weekly";

mkdir -p $backup_path;

tar -czf "$backup_path/$file_or_dir_to_backup_name-$(date +%d-%m-%Y).tar.gz" --absolute-name "$file_or_dir_to_backup_full_path";

find "$backup_path" -mtime +31 -type f -delete;

rsync --delete -a --mkpath "$backup_path" "vps@54.163.143.62:~/backups/$file_or_dir_to_backup_name/";
