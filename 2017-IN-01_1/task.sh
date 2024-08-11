#!/bin/bash

if [[ $# -ne 3 ]]; then 
    echo "Usage: $0 <file> <argument> <argument>"
    exit 1
fi

if ! grep -Eq "$2=" "$1" ; then
    echo "Expected to be in the file"
    exit 1
fi

firstTerms=$(grep -E "$2=" "$1" | cut -d'=' -f2)
if  grep -Eq "$3=" "$1" ; then
    old=$(grep -E "$3" "$1")
    secondTerms=$(grep -E "$3=" "$1" | cut -d'=' -f2)
    changedTerms=$secondTerms
    for first in $firstTerms
    do
        for second in $secondTerms 
        do
            if [[ $first =~ ^$second$ ]]; then 
                changedTerms=$(echo "$changedTerms" | sed "s/$second //")
            fi
            break
        done
    done
    new="$3=$changedTerms"
    sed -i "s/$old/$new/" "$1" #it can cause a problem during creating temp file to save the changes
    #alternative solution
    #sed "s/$old/$new/" "$1" > "$1.tmp" && mv "$1.tmp" "$1"
else
    cat $1
fi