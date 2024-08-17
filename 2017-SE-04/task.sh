#!/bin/bash
function symlinks()
{
    directory="$1"
    brokenLinks=$(find "$directory" -xtype l 2>/dev/null | wc -l)
    find "$directory" -type l -ls | rev | cut -d' ' -f1,2,3 | rev
    echo "Broken symlinks: $brokenLinks"
}

if [[ $# -gt 2 || $# -lt 1 ]]; then 
    echo "Usage: $0 <directory> <file>"
    exit 1
fi

directory="$1"

if [[ $# -eq 2 ]]; then 
    #has file
    file="$2"
    symlinks "$directory" > "$file"
else
    symlinks "$directory"
fi