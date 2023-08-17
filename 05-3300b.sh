#!/bin/bash

read -p "Input name of first file: " file1
if [[ ! -f "$file1" ]]; then
	echo "The first file DOESN'T exist!"
	exit 1
fi

read -p "Input name of second file: " file2
if [[ ! -f "$file2" ]]; then
	echo "The second file DOESN'T exist!"
	exit 1
fi

read -p "Input name of result file: " resultFile


paste "$file1" "$file2" | sort > "$resultFile"

