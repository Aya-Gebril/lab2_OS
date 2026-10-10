
#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <quarantine_directory>"
    exit 1
fi

MONITORED_DIR="$1"
QUARANTINE_DIR="$2"

if [ ! -d "$MONITORED_DIR" ] || [ ! -d "$QUARANTINE_DIR" ]; then
    echo "Error: both directories must exist."
    exit 1
fi

shopt -s nullglob

while true; do
    files=("$QUARANTINE_DIR"/*)

    if [ "${#files[@]}" -eq 0 ]; then
        echo "No malicious files to review."
        exit 0
    fi

    echo "Quarantined files:"
    for i in "${!files[@]}"; do
        echo "$((i + 1)). ${files[$i]##*/}"
    done

    echo "Choose a file number, or 0 to exit:"
    read -r choice

    if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid choice."
        continue
    fi

    if [ "$choice" -eq 0 ]; then
        exit 0
    fi

    if [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice."
        continue
    fi

    file="${files[$((choice - 1))]}"
    name="${file##*/}"

    echo "1. Restore"
    echo "2. Permanently delete"
    echo "3. Leave unchanged"
    read -r action

    case "$action" in
        1)
            if [ -e "$MONITORED_DIR/$name" ]; then
                echo "A file with this name already exists."
            elif mv -- "$file" "$MONITORED_DIR/$name"; then
                echo "Restored $name to $MONITORED_DIR."
                echo "$name" >> "$(cd "$(dirname "$0")" && pwd)/whitelist.txt"
            fi
            ;;
        2)
            if rm -- "$file"; then
                echo "$name permanently deleted."
            fi
            ;;
        3)
            continue
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done