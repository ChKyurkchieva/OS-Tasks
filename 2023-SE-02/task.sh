#!/bin/bash


if [[ $# -lt 2 ]]; then
        echo "Usage: <command> <seconds> <running_command> {<parameter>}"
        exit 1
fi

timeline=$1
shift
comm="$*"

startTime=$(date '+%s.%N' | awk '{printf "%.2f\n", $1}')
endTime=$(echo "$startTime + $timeline" | bc)

currentTime=$startTime
iterations=0
result=$(echo "$currentTime < $endTime" | bc)
while [ "$result" == "1" ]
do
        $comm >> /dev/null
        let iterations+=1
        currentTime=$(date "+%s.%N" | awk '{printf "%.2f\n", $1}')
        result=$(echo "$currentTime < $endTime" | bc)
done

resultTime=$(echo "$currentTime - $startTime" | bc)
averageTime=$(echo "scale=9; $resultTime / $iterations"| bc)
echo "Ran the command '$comm' $iterations times for $resultTime seconds."
echo "Average runtime: $averageTime seconds."