#!/bin/bash

if [[ $@ -gt 0 ]]; then 
	echo "Invalid number of variables\n"
	exit 1
fi

local_usernames=$(cut -d":" -f1 $PASSWD)

for user in $local_usernames
do 
	if [[ ! $(./occ user:list | grep $user) ]]; then
		./occ user:add "$user"
	else
		enabled_status=$(./occ user:info $user | grep -w "enabled" | cut -d':' -f2 | tr -d ' ')
		if [[ "$enabled_status" == "false" ]]; then
			./occ user:enable "$user"
		fi
	fi
done

prev_cloud_users=$(./occ user:list | awk -F':' '{print $1}') 
									#cut -d'' -f2|rev|cut -d':' -f2|rev)
for user in $prev_cloud_users
do
	if [[ ! $(grep -qw "$user" <<< "$local_usernames") ]]; then
		 ./occ user:disable "$user"
	fi
done


