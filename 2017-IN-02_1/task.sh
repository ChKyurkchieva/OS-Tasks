#!/bin/bash

function convertTime()
{
        tempFile=$(mktemp)
        awk -v convertedTime=0 '
        {
                time_str = $9
        split(time_str, time_parts, ":")
        hours = time_parts[1]
        minutes = time_parts[2]
        seconds = time_parts[3]
        total_seconds = hours * 3600 + minutes * 60 + seconds
        $9 = total_seconds
        print $0
        }' "$1" > "$tempFile"
        cp "$tempFile" "$1"
        rm "$tempFile"
}

function moreProceesses()
{
    userProcessesNumber=$(grep "^$2" $1 | wc -l)
    users=$(cat $1 | cut -d' ' -f1 | sort | uniq)
    for currentUser in $users;
    do
        currentUserProcessesNumber=$(grep "^$currentUser" $1 | wc -l)
        if [[ $currentUserProcessesNumber -gt $userProcessesNumber ]]; then
            echo "User $currentUser has more procceses than $2"
        fi
    done
}

function averageTime()
{
    time=$(cat "$1" | cut -d' ' -f9)
        lines=$(cat "$1" | wc -l)
    sumSeconds=0
    for line in $time
        do
                sumSeconds=$((sumSeconds + line))
        done

    if [[ $lines -gt 0 ]]; then
                averageSeconds=$(echo "scale=9; $sumSeconds / $lines" | bc)
                echo "$averageSeconds"
        else
        echo "Number of lines must be greater than zero."
        exit 1
        fi
}

function killProcceses()
{
    userPIDTime=$(grep "^$2" "$1" | cut -d' ' -f2,9)

    for line in $userPIDTime;
    do
        currentPID=$(echo "$line" | cut -d' ' -f1)
        currentTime=$(echo "$line" | cut -d' ' -f2)

                timeLimit=$(echo "scale=9; $3 * 2" | bc)

        if awk "BEGIN {exit !($currentTime > $timeLimit)}"; then
            echo "Killing process $currentPID for user $2 running for $currentTime time"
            #kill "$currentPID"
        fi
    done
}

if [[ $# -ne 1 ]]; then
    echo "Usage $0 <username>"
    exit 1
fi

if grep -c '^username:' /etc/passwd ; then
    echo "User $1 doesn't exist."
    exit 1
fi

user=$(whoami)
if [[ $user != "root" ]]; then
    processFile=$(mktemp)
    ps -e -o user=,pid=,%cpu=,%mem=,vsz=,rss=,tty=,stat=,time=,command= | tr -s ' ' > $processFile

    convertTime $processFile
    moreProceesses $processFile $user
    averageT=$(averageTime $processFile)
    killProcceses $processFile $user $averageT

    rm $processFile
else
    echo "Need to be root user to execute this script."
    exit 1
fi