# Antivirus Monitoring System

## Overview

This project implements a Bash-based antivirus monitoring system on Linux. It monitors a specified directory, detects potentially malicious files, moves them to a quarantine directory, and allows the user to restore or permanently delete quarantined files.

## Project Structure

```text
lab2_OS/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
├── monitored/
└── malicious/
```

* `antivirusd.sh`: Monitors the directory and detects suspicious files.
* `restore.sh`: Allows users to review quarantined files.
* `Makefile`: Provides commands to build and run the project.
* `monitored/`: Contains the files being monitored.
* `malicious/`: Stores quarantined files.

## Requirements

* Ubuntu or another Linux distribution
* Bash
* GNU utilities such as `find`, `grep`, `diff`, `cp`, and `rm`
* GNU Make

## Setup

Clone the repository:

```bash
git clone https://github.com/Aya-Gebril/lab2_OS.git
cd lab2_OS
```

Create the required directories and make the scripts executable:

```bash
mkdir -p monitored malicious
chmod +x antivirusd.sh restore.sh
make build
```

## Detection Rules

A file is considered suspicious if its filename ends with one of these extensions:

* `.exe`
* `.bat`
* `.vbs`
* `.scr`
* `.ps1`

Files are also checked for these case-insensitive keywords:

* `virus`
* `trojan`
* `malware`
* `worm`
* `ransomware`

## Running the Antivirus Daemon

Run the daemon using:

```bash
bash ./antivirusd.sh monitored malicious 5
```

The arguments are:

1. The directory to monitor.
2. The quarantine directory.
3. The monitoring interval in seconds.

The daemon scans files initially and then periodically checks for directory changes. When a suspicious file is detected, it is copied to the quarantine directory and removed from the monitored directory.

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

## Building the Project

Run:

```bash
make build
```

## Notes

This project uses simple filename and keyword checks to demonstrate antivirus monitoring. These checks do not replace a full antivirus engine and may identify harmless files as suspicious.
