#!/bin/bash

if [[ "$#" -ne 2 ]]; then
	echo "Error: Wrong number of arguments! The script expects TWO arguments."
	exit 1
fi

if [[ ! -d "$1" || ! -d "$2" ]]; then 
	echo "Error: The script expects TWO directories."
	exit 1
fi

SOURCE="$1"
DESTINATION="$2"

find "$SOURCE" -mindepth 1 -maxdepth 1 -type f | rev | cut -d'.' -f 1 | rev | sort | uniq | while read -r extension; do
    mkdir -p "$DESTINATION"/"$extension"
    find "$SOURCE" -mindepth 1 -maxdepth 1 -type f -name "*.$extension" -exec cp {} "$DESTINATION"/"$extension" \;
done 
