#!/bin/bash

for user in $(ps -eo user --no-headers --sort=-user | sort |uniq -c | rev | cut -d' ' -f1|rev); do
	if ! who | grep -q "^$user "; then
		echo "$user"
	fi
done
