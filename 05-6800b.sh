#!/bin/bash

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ "$#" -eq 2 ]]; then
	if [[ ! "$1"=~'^-a$' ]]; then
		echo "Error: Wrong parameter! Expected parameter: 'a'"
		exit 1
	fi

	if [[ ! -d "$2" ]]; then
		echo "Error: Second argument must be directory."
		exit 1
	fi
	argument=$1
	directory=$2

	find "$directory" -mindepth 1 -maxdepth 1 -type f -printf "%P (%s bytes) \n"
	find "$directory" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
		count=$(find "$subdir" | wc -l)
		echo "$subdir  ($count entries) "
	done
	 
else
	directory=$1
	if [[ ! -d "$1" ]]; then 
		echo "Error: First argument must be directory."
		exit 1
	fi

	find "$directory" -mindepth 1 -maxdepth 1 -type f ! -name '.*' -printf "%P (%s bytes) \n"
	find "$directory" -mindepth 1 -maxdepth 1 -type d ! -name '.*' | while read -r subdir; do
		count=$(find "$subdir" | wc -l)
		echo "$subdir  ($count entries) "
	done
	
fi


