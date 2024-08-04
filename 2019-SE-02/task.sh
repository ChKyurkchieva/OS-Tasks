#!/bin/bash

siStudents=$(mktemp)
cat /etc/passwd | grep "SI" | cut -d':' -f1,5,6 | sed 's/,,,,SI//g' >>$siStudents
startTime=1717437534
endTime=1720509820

filteredStudents=$(find /home/students -maxdepth 1 -mindepth 1 -type d -printf "%T@ %p\n" | awk -v start="$startTime" -v end="$endTime" '$1 >= start && $1 <= end {print $2}')

echo "$filteredStudents" |
while read -r line;     do
        if grep -q "$line" "$siStudents" ; then
                student=$(grep "$line$" $siStudents)
                fn=$(echo $student | cut -d':' -f1 | sed 's/s//')
                name=$(echo $student | cut -d':' -f2)
                printf "$fn\t$name\n"
        fi
done
rm $siStudents


    
    