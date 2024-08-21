#!/bin/bash
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <directory> <string>"
    exit 1
fi

if ! [[ -d $1 ]]; then
    echo "Expected directory as first argument"
    exit 1
fi

if ! [[ -n $2 ]]; then
    echo "Expected non-empthy string as second argument"
    exit 1
fi

fileNames=$(mktemp)
find "$1" -maxdepth 1 -type f -printf "%f\n" > "$fileNames" 
grep -E "^vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-$2$" "$fileNames" | sort --version-sort | tail -n 1 
rm "$fileNames"