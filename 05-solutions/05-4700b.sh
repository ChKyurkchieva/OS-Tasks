#!/bin/bash

if [[ $# -lt 1 || $# -gt 2 ]]; then
	echo "Error: Wrong number of arguments."
	exit 1
fi

if [[ ! $1 =~ ^-?[0-9]+$ ]]; then
	echo "Error: First argument must be integer."
	exit 1
fi

NUMBER="$1"

if [[ -z $2 ]]; then
	DELIMITER=" "
else
	DELIMITER="$2"
fi

if [[ $NUMBER =~ ^- ]]; then
    IS_NEGATIVE=true
    NUMBER="${NUMBER:1}"  # Remove the negative sign for processing
else
    IS_NEGATIVE=false
fi



FORMATED_NUMBER=$(echo "$NUMBER" | sed -r ":a; s/([0-9]+)([0-9]{3})/\1$DELIMITER\2/; ta")

if [[ $IS_NEGATIVE == true ]]; then
	FORMATED_NUMBER="-${FORMATED_NUMBER}"
fi

echo "$FORMATED_NUMBER"

