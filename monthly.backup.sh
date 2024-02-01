#!/bin/bash

file_or_dir_to_backup_full_path="$1";
file_or_dir_to_backup_name="$(basename $1)";

backup_path="$HOME/backups/$file_or_dir_to_backup_name/monthly";

mkdir -p $backup_path;

tar -czf "$backup_path/$file_or_dir_to_backup_name-$(date +%d-%m-%Y).tar.gz" --absolute-name "$file_or_dir_to_backup_full_path";

find "$backup_path" -mtime +366 -type f -delete;

rsync --delete -a --mkpath "$backup_path" "vps@192.168.1.0:~/backups/$file_or_dir_to_backup_name/";
