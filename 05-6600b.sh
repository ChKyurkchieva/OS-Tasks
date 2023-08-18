#!/bin/bash

if [[ "$#" -ne 1 ]]; then 
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ ! -d "$1" ]]; then 
	echo "Error: The argument must be directory."
	exit 1
fi

cd "$1"

find . -type f -exec md5sum {} + | sort | uniq -w32 -d --all-repeated=separate | cut -f3- -d ' ' |
while read -r first; do
    # Прочитане на останалите дублирани файлове
    read -r next
    while [ -n "$next" ]; do
        rm "$next"
        read -r next
    done
done

