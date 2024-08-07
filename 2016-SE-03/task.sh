#!/bin/bash
noHomeDirectory()
{
    user=$1
    directory=$2
    writePerm=$(namei -l $directory | tail -n 1 | cut -c3)
    if ! [[ -d $directory && $writePerm == "w" ]]; then
        grep "$user" /etc/passwd
    fi
}

user=$(whoami)
if [[ user == "root" ]];then
        for line in $(cat /etc/passwd | cut -d':' -f1,6);
    do
        user=$(echo $line | cut -d':' -f1)
        directory=$(echo $line | cut -d':' -f2)
        noHomeDirectory $user $directory
    done
else
    echo "Root user expected! You are not root."
    exit 1
fi