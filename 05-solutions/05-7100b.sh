#!/bin/bash

if [[ "$#" -ne 2 ]]; then
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ ! -d "$1" ]]; then
	echo "Error: First argument must be directory."
	exit 1
fi

if [[ ! $2 =~ ^[0-9]+$ ]]; then 
	echo "Error: Second argument must be positive integer."
	exit 1
fi

directory="$1"
number="$2"

find "$directory" -mindepth 1 -maxdepth 1 -type f -size +"$number" -printf "%P\n"
