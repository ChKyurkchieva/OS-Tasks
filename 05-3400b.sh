#!/bin/bash

read -p "Input name of file: " file

read -p "Input string: " string 

if [[ ! -f "$file" ]]; then
	echo "Error! File with this name DOESN'T exist! "
	exit 1
fi

grep -q "$string" "$file"

echo $?
