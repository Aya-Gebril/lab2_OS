
#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
MONITORED_DIR="$BASE_DIR/monitored"
QUARANTINE_DIR="$BASE_DIR/malicious"

mkdir -p "$QUARANTINE_DIR"

find "$MONITORED_DIR" -maxdepth 1 -type f -print0 |
while IFS= read -r -d '' file; do
    name="${file##*/}"

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