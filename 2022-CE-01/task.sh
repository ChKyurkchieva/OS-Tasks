#!/bin/bash
user=$(whoami)
directory="$HOME"
files=$( find $directory -type f -maxdepth 1 -user "$user" 2>/dev/null)

for file in $files;
do 
    chmod o-w $file
done