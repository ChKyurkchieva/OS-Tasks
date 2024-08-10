#!/bin/bash

function extractSongs()
{
    name=$(echo "$1")
    directory=$(pwd)
    newFile="$directory/$name.songs"
    cat $1 | cut -d' ' -f 4- | sort >> $newFile
}

if [[ $# -ne 2 ]]; then 
echo "Usage: $0 <file_name> <file_name>"
exit 1
fi

if ! [[ -f $1 && -f $2 ]]; then
echo "Expected two file names as arguments."
exit 1
fi

firstFileName=$(echo "$1")
secondFileName=$(echo "$2")
firstFileWords=$(grep -o "$firstFileName" $1 | wc -w)
secondFileWords=$(grep -o "secondFileName" $2 | wc -w)

if [[ $firstFileWords -gt $secondFileWords ]]; then
    extractSongs $1
else
    extractSongs $2
fi