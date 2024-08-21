#!/bin/bash

function uniqLines()
{
    source="$1"
    destination="$2"
    temp=$(mktemp)
    while IFS= read -r line; do 
        info=$(echo "$line" | cut -d',' -f2-)
        matches=$(grep -F "$info" "$source")
        lines=$(echo "$matches" | wc -l)
        if [[ $lines -eq 1 ]]; then
            echo "$matches" >>"$destination"
            echo "$matches" >>"$temp"
        else
            echo "$matches" | sort -n -k1,1 | head -n 1 >> "$temp"
        fi
    done < "$source"
    mv "$temp" "$source"
}

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <csv_source_file> <csv_destination_file>"
    exit 1
fi 

if [[ ! -f $1 ]]; then 
    echo "$1 must be a file"
    exit 1
fi

uniqLines "$1" "$2"