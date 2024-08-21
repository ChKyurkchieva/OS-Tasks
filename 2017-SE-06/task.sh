#!/bin/bash

function notOwningHomeDirectory()
{
    while IFS=: read -r user homeDirectory; do
        if [[ -d "$homeDirectory" ]]; then 
            owner=$(find $homeDirectory -maxdepth 0 -ls | tr -s ' ' | cut -d' ' -f6)
            if [[ "$user" != "$owner" ]]; then 
                echo "$user"
            fi
        fi
    done < /etc/passwd
}

function alternative()
{
    for user in $(cut -d':' -f1 /etc/passwd);
    do
        homeDirectory=$(eval echo ~$user)
        if [ -d "$homeDirectory" ] && [ "$(stat -c %U "$homeDirectory")" != "$user" ]; then
            echo $user
        fi
    done
}

function nonExistentDirectories()
{
    cat /etc/passwd | awk -F: '($6 == "" || $6 == "/nonexistent") {print $1}'
}

function noWritingOwnerPermitions()
{
    for user in $(cut -d':' -f1 /etc/passwd); 
    do 
        homeDirectory=$(eval echo ~$user)
        writePermition=$(find "$homeDirectory" -maxdepth 0 -ls | tr -s ' ' | cut -d' ' -f4 | cut -c3)
        if [[ $writePermition != "w" ]]; then
            echo $user        
        fi
    done
}

function sumRSS()
{
    user="$1"
    file="$2"
    grep "^$user" "$file" | awk '{sum+=$3} END {print sum}'
}

function killProcesses()
{
    psFile=$(mktemp)
    ps -e -o user=,pid=,rss= | tr -s ' ' > $psFile
    rootRSS=$(sumRSS "root" "$psFile")
    users=$(mktemp)
    notOwningHomeDirectory >> $users
    nonExistentDirectories >> $users
    noWritingOwnerPermitions >> $users
    uniqUsers=$(cat "$users" | sort | uniq)
    for user in $uniqUsers; 
    do
        userRSS=$(sumRSS "$user" "$psFile")
        if [[ $userRSS -gt $rootRSS ]]; then
            pids=$(grep -E "^$user" | cut -d' ' -f2)
            kill $pids
        fi
    done 
    rm "$users" "$psFile"
}

user=$(whoami)
if [[ $user == "root" ]]; then 
    killProcesses
else
    echo "You are not root user."
    exit 1
fi