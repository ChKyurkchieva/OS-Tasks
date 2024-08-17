#!/bin/bash
user=$(whoami)
if [[ $user == "root" ]]; then
    psFile=$(mktemp)
    ps -e -o uid=,pid=,rss= | tr -s ' ' | rev | cut -d' ' -f1,2,3 | rev  >  $psFile
    users=$(cat "$psFile" | cut -d' ' -f1 | sort -n | uniq)
    for currentUser in $users; 
    do

        rss=$(grep -E "^$currentUser " "$psFile" | cut -d' ' -f3 | sort -n)
        lines=$(echo "$rss" | wc -l)
        if [[ $lines -gt 0 ]]; then
            sum=$(echo "$rss" | awk '{sum+=$1} END {print sum}')
            average=$(echo "scale=2; $sum/$lines" | bc)
            limit=$( echo "$average * 2" | bc )
            biggestRSS=$(echo "$rss" | tail -n 1)
            if (( $(echo "$biggestRSS > $limit" | bc -l) )); then
                pid=$(grep -E "^$currentUser " "$psFile" | sort -n -k3,3 | tail -n 1 | awk '{print $2}')
                kill "$pid"
            fi
        else
            echo "Trying to divide by 0"
        fi
    done
    rm "$psFile" 
else
    echo "User expected to be root."
fi
