#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: <command> <file>"
    exit 1
fi

file=$1
type=$(sed '1d' $file | sed 's/;/ /g' | sort -nr -k3,3 | head -n 1 | cut -d' ' -f 2)
grep $type $file | sed 's/;/ /g' | sort -n -k3,3 | head -n1