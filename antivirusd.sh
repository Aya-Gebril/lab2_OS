
#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <directory> <quarantine_directory> <interval_seconds>"
    exit 1
fi

MONITORED_DIR="$1"
QUARANTINE_DIR="$2"
INTERVAL="$3"

if [ ! -d "$MONITORED_DIR" ] || [ ! -d "$QUARANTINE_DIR" ]; then
    echo "Error: both directories must exist."
    exit 1
fi

if ! [[ "$INTERVAL" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: interval must be a positive integer."
    exit 1
fi

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LAST="$BASE_DIR/directory-info.last"
NEW="$BASE_DIR/directory-info.new"

WHITELIST="$BASE_DIR/whitelist.txt"
touch "$WHITELIST"

scan_files() {
    find "$MONITORED_DIR" -maxdepth 1 -type f -print0 |
    while IFS= read -r -d '' file; do
        name="${file##*/}"
        if grep -Fxq -- "$name" "$WHITELIST"; then
            continue
        fi
        case "$name" in
            *.exe|*.bat|*.vbs|*.scr|*.ps1)
                malicious=true
                ;;
            *)
                if grep -Eiq 'virus|trojan|malware|worm|ransomware' "$file"; then
                    malicious=true
                else
                    malicious=false
                fi
                ;;
        esac

        if [ "$malicious" = true ]; then
            if cp -- "$file" "$QUARANTINE_DIR/$name"; then
                echo "$name is malicious and it is DELETED"
                rm -- "$file"
            fi
        fi
    done
}

ls -l "$MONITORED_DIR" > "$LAST"
scan_files
ls -l "$MONITORED_DIR" > "$LAST"

while true; do
    sleep "$INTERVAL"
    ls -l "$MONITORED_DIR" > "$NEW"

    if ! diff -q "$LAST" "$NEW" >/dev/null; then
        scan_files
        ls -l "$MONITORED_DIR" > "$LAST"
    fi
done