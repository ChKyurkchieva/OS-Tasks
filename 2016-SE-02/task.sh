#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <number>"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Expected number as argument!"
    exit 1
fi

user=$(whoami)

if [[ $user == "root" ]];then
    tempFile=$(mktemp)
        summedRSS=$(mktemp)

    ps -eo uid=,pid=,rss= | sort -n -k1,1 | tr -s ' ' | rev | cut -d' ' -f1,2,3 | rev > $tempFile
    awk '{sum[$1] += $3} END {for (i in sum) print i, sum[i]}' $tempFile >> $summedRSS
    cat $tempFile
    while read -r line; do
        lineUID=$(echo $line | awk '{print $1}')
        lineSum=$(echo $line | awk '{print $2}')

        if [[ $lineSum -ge $1 ]]; then
            killPID=$(awk -v uid="$lineUID" '$1 == uid {print $2, $3}' $tempFile | sort -nr -k2,2 | head -n 1 | awk '{print $1}')
            kill $killPID
        fi
    done < $summedRSS
    rm $tempFile $summedRSS
else
    echo "Root user expected! You are not root."
    exit 1
fi