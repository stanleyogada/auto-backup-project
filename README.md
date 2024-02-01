# AUTO BACKUP SCRIPT

**Author: Stanley Chinedu Ogada**

## Overview
The script automates the addition of backup tasks to the crontab for daily (04:00 AM), weekly (Sundays, 02:00 AM), and monthly (Sundays, 02:00 AM) backups. All compressions (`.tar.gz`) are stored in a backup directory in the user's home directory (`~/.backups/`), and SSH key authentication is required for remote hosts.

Only keeps the most recent (7) daily backup files, (4)  weekly backup files, and (12) monthly backup files. Hence deleting older backup files.


## Usage (3 easy steps)

Follow these three steps to set up and run the backup script:

1. **Clone the Project:**
   ```bash
   git clone https://github.com/stanleyogada/auto-backup-project.git
   ```

2. **Change to the Project's Directory (Very important⛔️):**
   ```bash
   cd auto-backup-project
   ```

3. **Run the Init Script (You might be asked your sudo password):**
   ```bash
   ./init.backup.sh "/path/to/important-file /another-important-file" "user@remote-host" "/path/to/ssh/private-key"
   ```
   > Note: this is a one-time run and you may need to edit the cron job/s by yourself if you wish to make any changes. \
   > Simply run `crontab -e` if you need to edit the jobs manually.

## Explanation of Script Arguments

- **Argument 1 (`all_important_files_paths`):**
  - Description: A string containing 1 or multiple paths of directories or files to be backed up, separated by spaces.
  - Example: `"/home/local/important-file /another-important-file"`

- **Argument 2 (`remote_host`):**
  - Description: A string representing the remote host in the format `user@hostname`.
  - Example: `"user@192.168.1.0"`

- **Argument 3 (`ssh_private_key`):**
  - Description: A string containing the path to the private SSH key for authentication to the remote host.
  - Example: `"/home/local/.ssh/private-key"`

## A Real-World Scenario usage of the init script 🧪

Assuming you have set up SSH public-key authentication with a remote system (`stanley@ec2.com`) with a private key (`~/.ssh/ec2-key`), and you want to back up your important `~/Videos/` and `~/Web-App/` directories, you can run the following command:

```bash
./init.backup.sh "/home/stanley/Videos /home/stanley/Web-App" "stanley@ec2.com" "/home/stanley/.ssh/ec2-key"
```

In this example, the script will schedule daily, weekly, and monthly backups for the specified files to the remote host using the provided SSH key.

### Additional Information

- **Local Backups Directory:**
  - `$HOME/.backups/`

- **Remote Backups Directory:**
  - `$remote_host:~/backups`

- **Logs Directory:**
  - `$HOME/.backups/.logs/`

- **Tree structure:**
<img width="523" alt="image" src="https://github.com/stanleyogada/auto-backup-project/assets/102979724/543e6d75-8156-4684-9afe-56ad17495889">


> If you encounter errors in appropriate behaviors, make sure to double your paths (Note: re-running the init script will not write another cron job/s, so edit them yourself if you want to troubleshoot).\
> Make sure you the private key the correct key


*Note: This documentation was authored by Stanley Chinedu Ogada. If you have any questions or encounter issues, feel free to reach out for personalized assistance.*
