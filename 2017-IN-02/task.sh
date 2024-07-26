#!/bin/bash

#find . -type f -empty -exec rm {}+
find . -type f -empty | while read -r file; do
    rm "$file"
done

homeDirectory=$(eval echo ~$USER)
#find "$homeDirectory" -type f -exec du -a {}+ | sort -nr | head -n 5 | cut -f2 | xargs -d '\n' rm 
find "$homeDir" -type f -exec du -a {} + | sort -nr | head -n 5 | cut -f2- | while read -r file; do
    rm "$file"
done