#!/bin/bash

if [[ $# -ne 2 ]]; then 
    echo "Usage: $0 <file> <directory>"
    exit 1
fi

if [[ ! -s $1 ]]; then 
    echo "$1 is empty file."
    exit 1
fi

if ! [[ -d $2 ]]; then 
    echo "$2 is not directory" 
    exit 1
fi

rm -r "$2"/*

namesFile=$(mktemp)
cat "$1" | cut -d':' -f1 | tr -s ' ' | cut -d'(' -f1 | sort | uniq > "$namesFile"
tmp=$(mktemp)
awk '{print $0 ";" NR}' "$namesFile" > "$tmp" && mv "$tmp" "$namesFile"
while IFS=';' read -r name lineNumber; 
do
    grep -E "$name" "$1" | cut -d':' -f2 >> "$2/$lineNumber.txt"
done < "$namesFile"

rm "$namesFile"


