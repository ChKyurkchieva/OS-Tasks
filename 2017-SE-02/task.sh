#!/bin/bash

if [[ $# -ne 3 ]]; then 
    echo "Usage: $0 <source_directory> <destination_directory> <string>"
    exit 1
fi

if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then 
    echo "Expected directory as first and second arguments"
    exit 1
fi
source="$1"
destination="$2"
str="$3"
user=$(whoami)
if [[ -n $str ]]; then #not empty
    if [[ $user == "root" ]]; then
        filesToMove=$(mktemp)
        find "$source" -name "*$str*" > "$filesToMove"
        while IFS= read -r file; do 
            relative_path="${file#$source/}" #path relative to the source directory
            mkdir -p "$destination/$(dirname "$relative_path")" #create nessesary directory structure
            mv "$file" "$destination/$relative_path" #move the file
        done < "$filesToMove"
        rm $filesToMove
    fi
else
    echo "Empty last argument"
    exit 1
