#!/bin/bash

if [[ "$#" -ne 2 ]]; then
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ ! -f "$1" ]]; then
	echo "Error: First argument must be file."
	exit 1
fi

if [[ ! -d "$2" ]]; then 
	echo "Second argument must be directory."
	exit 1
fi

file=$1
directory=$2

original_md5=$(md5sum "$file" | cut -d' ' -f1)

find "$dictionary" -type f -exec md5sum {} \; | while read -r line; do 
	current_md5=$(echo $line | cut -d' ' -f1)
	current_file=$(echo $line | cut -d' ' -f2-)

	if [ "$original_md5" == "$current_md5" ] && [ "$file" != "$current_file" ]; then
		echo "Found a copy: $current_file"
	fi
done


