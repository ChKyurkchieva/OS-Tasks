#!/bin/bash
file="spacex.txt"
numLines=$(( $(wc -l $file | cut -d' ' -f1) - 1 ))
fLauchSite=$(awk -F'|' '{print $2 " " $3}' "$file" | grep 'Failure' | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 1 | rev | cut -d' ' -f1 | rev)
grep $fLauchSite $file | sort -rn -k1,1 | head -n 1 | cut -d'|' -f3,4 | sed 's/|/:/g'