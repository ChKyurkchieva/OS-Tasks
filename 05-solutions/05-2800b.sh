#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Error: Exactly one argument is required."
	exit 1
fi

if [[ ! "$1" =~ ^[a-zA-Z0-9]+$ ]]; then
	echo "Error: Argument should only consist of letters and numbers."
	exit 1
fi

echo "The argument is valid."
