#!/bin/bash

if [[ $# -lt 1 || $# -gt 2 ]]; then
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "Error: First argument must be a directory."
	exit 1
fi

SOURCE_DIRECTORY=$1

if [[ $# -eq 1 ]]; then
	DEST_DIR=$(date "+%Y-%m-%d_%H-%M-%S")
    mkdir -p "$DEST_DIR"

elif [[ $# -eq 2 ]]; then	
	if [[ ! -d $2 ]]; then
		echo "Error: Second argument must be a directory."
		exit 1
	fi

	DESTINATION_DIRECTORY=$2
fi

cp $(find "$SOURCE_DIRECTORY" -type f -mmin -45) "$DESTINATION_DIRECTORY"

