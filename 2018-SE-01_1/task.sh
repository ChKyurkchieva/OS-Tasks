#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <log_directory>"
    exit 1
fi

if ! [[ -d $1 ]]; then 
    echo "Expected directory as argument"
    exit 1
fi
fileLines=$(mktemp)
friends=$(find "$1" -mindepth 3 -maxdepth 3 -type d)
for friend in $friends; 
do 
    friendLines=$(find "$friend" -type f -exec wc -l {} + | tail -n 1 | awk '{print $1}')
    echo "$(basename $friend) $friendLines" >> "$fileLines"
done 

awk '{sum[$1] += $2} END {for (name in sum) print name, sum[name]}' "$fileLines" | sort -rn -k2,2 | head -n10
rm "$fileLines"