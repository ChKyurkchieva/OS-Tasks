#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Error: Exactly one argument is required."
	exit 1
fi

if ! grep -q "^$1:" /etc/passwd; then
	echo "The account '$1' does not exist on the system."
	exit 1
fi

SESSION_COUNT=$(who | grep -wc "$1")

echo "The user $1 has $SESSION_COUNT active session(s)."

