# Antivirus Monitoring System

## Overview

This project implements a Bash-based antivirus monitoring system on Linux. It monitors a specified directory, detects potentially malicious files, moves them to a quarantine directory, and allows the user to restore or permanently delete quarantined files.

## Project Structure

```text
lab2_OS/
├── antivirusd.sh
├── antivirus-cron.sh
├── restore.sh
├── whitelist.txt
├── Makefile
├── README.md
├── monitored/
└── malicious/
```

* `antivirusd.sh`: Continuously monitors the directory and detects suspicious files.
* `antivirus-cron.sh`: Performs a scheduled scan using Cron.
* `restore.sh`: Allows users to review quarantined files, restore them, or permanently delete them.
* `whitelist.txt`: Stores filenames that have been marked as safe.
* `Makefile`: Provides commands to build and run the project.
* `monitored/`: Contains the files being monitored.
* `malicious/`: Stores quarantined files.

## Requirements

* Ubuntu or another Linux distribution.
* Bash.
* GNU utilities such as `find`, `grep`, `diff`, `cp`, and `rm`.
* GNU Make.
* Cron for scheduled scanning.

## Setup

Clone the repository:

```bash
git clone https://github.com/Aya-Gebril/lab2_OS.git
cd lab2_OS
```

Create the required directories and make the scripts executable:

```bash
mkdir -p monitored malicious
chmod +x antivirusd.sh antivirus-cron.sh restore.sh
make build
```

The antivirus scripts automatically create `whitelist.txt` if it does not exist.

## Detection Rules

A file is considered suspicious if its filename ends with one of these extensions:

* `.exe`
* `.bat`
* `.vbs`
* `.scr`
* `.ps1`

Files with other extensions are also checked for these case-insensitive keywords:

* `virus`
* `trojan`
* `malware`
* `worm`
* `ransomware`

When a suspicious file is detected, it is copied to the quarantine directory and then removed from the monitored directory.

## Running the Antivirus Daemon

Run the daemon using:

```bash
bash ./antivirusd.sh monitored malicious 5
```

The arguments are:

1. The directory to monitor.
2. The quarantine directory.
3. The monitoring interval in seconds.

The daemon scans files initially and then periodically checks for directory changes. When a suspicious file is detected, it is moved to quarantine.

Press `Ctrl+C` to stop the daemon.

You can also use:

```bash
make run
```

## Reviewing Quarantined Files

Run:

```bash
bash ./restore.sh monitored malicious
```

Or use:

```bash
make restore
```

For each quarantined file, choose one of these actions:

1. Restore the file to the monitored directory.
2. Permanently delete the file.
3. Leave the file in quarantine.

## Whitelist

When a quarantined file is restored through `restore.sh`, its filename is appended to `whitelist.txt`, marking it as a false positive.

During each scan, both `antivirusd.sh` and `antivirus-cron.sh` check whether the filename appears in `whitelist.txt`. If it does, the file is skipped even if its extension or content matches a detection rule.

The whitelist persists across daemon restarts because it is stored in a file in the project directory.

**Note:** The whitelist matches filenames, not file contents or unique file paths. A different file with the same name will also be skipped.

## Cron Job Setup

### Prerequisites

Before configuring the Cron job, make sure that:

* Ubuntu or another Linux distribution is available.
* Bash and the required GNU utilities are installed.
* Cron is installed and running.
* The project files and the `monitored/` and `malicious/` directories exist.
* The scripts have the required permissions.

### Configure the Cron Job

**Step 1: Install Cron if necessary.**

```bash
sudo apt update
sudo apt install cron
```

**Step 2: Enable and start the Cron service.**

```bash
sudo systemctl enable --now cron
```

**Step 3: Make the scripts executable.**

```bash
chmod +x antivirus-cron.sh antivirusd.sh restore.sh
```

**Step 4: Open the current user's crontab.**

```bash
crontab -e
```

**Step 5: Add the following entry.**

```cron
* * * * * sleep 23; /bin/bash /home/aya_gebril/lab2_OS/antivirus-cron.sh >> /home/aya_gebril/lab2_OS/cron.log 2>&1
```

This schedules a scan every minute, approximately 23 seconds after the beginning of each minute. Replace `/home/aya_gebril/lab2_OS` with the absolute path to the project directory if it is different.

**Step 6: Save the crontab and verify the entry.**

```bash
crontab -l
```

**Step 7: Check the scan log.**

```bash
cat /home/aya_gebril/lab2_OS/cron.log
```

The log records the output and errors produced by the scheduled scan.

### Cron Expression: Third Friday at 12:31 AM

To run a command only on the third Friday of each month at 12:31 AM, use:

```cron
31 0 15-21 * * [ "$(date +\%u)" -eq 5 ] && /path/to/command
```

The day-of-month range restricts execution to dates from the 15th through the 21st. The date check ensures that the command runs only when the date falls on a Friday. Replace `/path/to/command` with the command you want to execute.

## Building the Project

Build the project using:

```bash
make build
```

## Cleaning Generated Files

Remove generated directory snapshots using:

```bash
make clean
```

## Notes

This project uses simple filename and keyword checks to demonstrate antivirus monitoring. These checks do not replace a full antivirus engine and may identify harmless files as suspicious.
