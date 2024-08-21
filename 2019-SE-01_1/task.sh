#!/bin/bash

abs() 
{
    if [[ "$1" -lt 0 ]]; then
        echo $(( -1 * $1 ))
    else
        echo $1
    fi
}

function findAbsolute()
{
    numbers="$1"
    sortedNumbers=$(sort -n "$numbers" | uniq)
    smallest=$(echo $sortedNumbers | head -n 1)
    biggest=$(echo $sortedNumbers | tail -n 1)
    absoluteSmallest=$(abs "$smallest")
    absoluteBiggest=$(abs "$biggest")
    if [[ "$absoluteSmallest" -gt "$absoluteBiggest" ]]; then
        echo "$smallest"
    elif [[ "$absoluteSmallest" -eq "$absoluteBiggest" ]]; then
        echo "$smallest"
        echo "$biggest"
    else
        echo "$biggest"
    fi
}

sumOfDigits() 
{
    number=$(abs "$1")
    sum=0
    while [ "$number" -ne 0 ]; do
        digit=$(( number % 10 ))    
        sum=$(( sum + digit ))      
        number=$(( number / 10 ))   
    done

    echo $sum
}

function smallestWithBigestDigitSum()
{
    temp=$(mktemp)
    numbers="$1"
    while IFS= read -r number;
    do
        echo "$(sumOfDigits $number) $number" >> "$temp"
    done < "$numbers"
    echo "$(sort -nr -k1,1 "$temp" | sort -n k2,2 | awk '!seen[$2]++' | head -n 1 | cut -d' ' -f2)"
    rm "$temp"
}

numbers=$(mktemp)
while IFS= read -r line; do
    grep -Eo "-{0,1}[0-9]+\.{0,1}[0-9]*" <<< "$line" >> $numbers
done
findAbsolute "$numbers"
smallestWithBigestDigitSum "$numbers"
rm "$numbers"