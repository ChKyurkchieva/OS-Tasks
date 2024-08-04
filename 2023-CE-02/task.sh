#!/bin/bash
directory="/var/log/my_logs"
totalErrors=0
find $directory -type f -name "*.log" | while IFS= read -r file; do
    if [[ "$(basename "$file")" =~ ^[a-zA-Z0-9_]+_[0-9]+\.log$ ]]; then
        count=$(grep -o "error" $file | wc -l)
        totalErrors=$((totalErrors + count))
    fi
done

echo $totalErrors