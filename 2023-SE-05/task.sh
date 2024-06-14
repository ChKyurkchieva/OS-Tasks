#!/bin/bash

#commRSS=$(ps -eo rss,comm | sort -n | awk '$1 >= 10000 {print $2}')

#echo "$commRSS"

file_path="/home/students/s45523/temp_file"
touch $file_path
num_checks=0
while true
do
	ps -eo rss,comm | awk '$1>=10000 {print $2}' >> "$file_path"

	((num_checks++))

	sleep 1
	if [[ -z "$(ps -eo rss,comm | awk '$1>=10000 {print $2}')" ]]; then
		break;
	fi
done

sort $file_path | uniq -c | awk -v num_checks="$num_checks" '$1 > (num_checks / 2) {print $2}' 

rm "$file_path"
