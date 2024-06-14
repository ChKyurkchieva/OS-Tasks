#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Invalid number of parameters. Expected one parameter"
	exit 1
fi

if [[ ! -d $1 ]]; then 
	echo "Expected directory"
	exit 1
fi

hash_sums=$(mktemp)
files=$(find "$1" -type f)
for file in "$files"
do
	md5sum "$file" >> "$hash_sums"
done

uniq_sums=$(mktemp)
sort -k 1,1 "$hash_sums" | uniq -c | rev | cut -d' ' -f 1,2 | rev > "$uniq_sums"

groups_dedup=$(awk '$1 > 1 {print}' $uniq_sums | wc -l) 

sorted_file=$(sort -k 1,1 "$hash_sums")

last_file_to_keep=$(echo "$sorted_file" | head -n1 | cut -d' ' -f1)
last_hash_to_keep=$(echo "$sorted_file" | head -n1 | cut -d' ' -f2)
freed_memory=0

for line in "$sorted_file"
do
	file=$(echo "$line" | cut -d' ' -f2)
	hashs=$(echo "$line" | cut -d' ' -f1)
	if [[ "$hashs" == "$last_hash_to_keep" && "$file"!="$last_file_to_keep" ]]; then
		# dedup
		ln -sf "$last_file_to_keep" "$file"
		freed_memory+=$(stat -c %s $last_file_to_keep)	
	else
		last_file_to_keep="$file"
		last_hash_to_keep="$hashs"
	fi
done

echo "Groups dedup: $groups_dedup"
echo "Bytes freed: $freed_memory"

rm "$hash_sums"
rm "$uniq_sums"
