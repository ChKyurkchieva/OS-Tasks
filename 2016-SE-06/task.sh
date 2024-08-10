#!/bin/bash
if [[ $# -ne 1 ]]; then 
echo "Usage: $0 <file_name>"
exit 1
fi 

if ! [[ -f $1 ]]; then 
echo "Expected file as argument"
exit 1
fi 

cat $1 | cut -d' ' -f 4- | nl -s ". " | sort -k2