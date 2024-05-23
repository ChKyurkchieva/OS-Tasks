#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Error: Invalid number of arguments! One argument is required."
	exit 1
fi

if [[ "$1" == ~* ]]; then
	echo "$1 starts with a tilde (~) and is not accepted."
	exit 1
fi

if [[ ! ("$1" == /* && -d "$1") ]]; then
	echo "$1 is NOT an absolute path to a directory."
	exit 1
fi

FILES_COUNT=$(find $1 -maxdepth 1 -type f | wc -l)
DIRECTORIES_COUNT=$(find $1 -maxdepth 1 -type d | wc -l)

echo "In directory $1 there is $FILES_COUNT files and $DIRECTORIES_COUNT directories."
