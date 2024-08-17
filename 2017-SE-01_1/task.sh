#!/bin/bash

if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then 
    echo "Usage: $0 <directory> <number-obptional>"
    exit 1
fi

if ! [[ -d $1 ]]; then
    echo "Expected directory as first argument"
    exit 1
fi

directory="$1"

if [[ $# -eq 2 ]]; then
    if [[ $2 =~ ^[0-9]+$ ]]; then
        hardlinks="$2"
        find "$directory" -type f -links +"$hardlinks" -name '*' -printf "%p\n" 2>/dev/null
    else
        echo "Expected number as second argument"
        exit 1
    fi
else
    find "$directory" -xtype l 2>/dev/null # find "$directory" -type l for symlinks [not broken ones]
fi
