#!/bin/bash

if [[ ! $# -eq 3 ]]; then 
	echo "Error: Expected three arguments!"
	exit 3
fi

NUMBER=$1
INTERVAL_START=$2
INTERVAL_END=$3

is_integer() {
    local num="$1"
    [[ "$num" =~ ^-?[0-9]+$ ]]
}

if ! is_integer "$NUMBER" || ! is_integer "$INTERVAL_START" || ! is_integer "$INTERVAL_END"; then
	echo "Some of arguments are not integers."
	exit 3
fi

if [[ "$INTERVAL_START" -gt "$INTERVAL_END" ]]; then 
	exit 2
fi

if [ "$NUMBER" -ge "$INTERVAL_START" ] && [ "$NUMBER" -le "$INTERVAL_END" ]; then
	exit 0
else
	exit 1
fi
