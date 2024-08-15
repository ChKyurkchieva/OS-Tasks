#!/bin/bash

if [[ $# -ne 0 ]]; then
    echo "Usage: $0"
    exit 1
fi

usersInfo=$(mktemp)
cat "/etc/passwd" | grep -v "/nonexistent" | grep -v "/nologin" | cut -d':' -f1,6 > $usersInfo
fileName=$(head -n 1 "$usersInfo" | cut -d':' -f2)
time=0
user=$(head -n 1 "$usersInfo" | cut -d':' -f1)
while read -r line;
do
    currentUser=$(echo "$line" | cut -d':' -f1)
    directory=$(echo "$line" | cut -d':' -f2)
    currentFileInfo=$(find $directory -type f -printf "%p %T@\n" 2>/dev/null | sort -rn -k2,2 | head -n 1) #all files with time of modification

    if [[ -z "$currentFileInfo" ]]; then
        continue  # Skip this iteration if no file was found
    fi

    currentFileName=$(echo "$currentFileInfo" | cut -d' ' -f1)
    currentTime=$(echo "$currentFileInfo" | cut -d' ' -f2)
    if [[ -n "$currentTime" ]] && [[ $(echo "$currentTime > $time" | bc) -eq 1 ]]; then
            time=$currentTime
            fileName=$currentFileName
            user=$currentUser
    fi
done < "$usersInfo"
echo "User $user with the highest ctime file $fileName"
rm $usersInfo