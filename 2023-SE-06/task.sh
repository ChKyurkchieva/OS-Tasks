#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <source_directory_path> <destination_directory_path> "
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "Invalid argument! Expected directory"
	exit 1
fi

mkdir -p $2

photos=$(find $1 -type f -iname "*.jpg" -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" | sort -n) # 2000-01-01 20:10:15.99972421 photo.jpg
start_interval=$(echo "$photos" | head -n1 | cut -d' ' -f1)
end_interval=$start_interval
mkdir -p "temp_dir"

for photo in "$photos"
do
	photo_date=$(echo "$photo" | cut -d' ' -f1)
	next_date=$(date -d "$end_interval + 1 day" +'%Y-%m-%d')
	
	if [[ "$end_interval" == "$photo_date" || "$next_date" == "$photo_date" ]]; then
		end_interval=$photo_date
		name_photo=$( echo "$photo" | cut -d' ' -f 3)
		new_name_photo=$(echo "$photo" | cut -d' ' -f 1,2 |cut -d'.' -f1| tr ' ' '_')
		new_name_photo+=".jpg"
		cp "$name_photo" "$temp_dir/$new_name_photo"
	else

		directory="${start_interval}_$end_interval"
		mkdir -p "$2/$directory"
		cp -p $temp_dir/* "$2/$directory/"
		rm "temp_dir"/*
		start_interval="$photo_date"
		end_interval="$start_interval"
	fi
done

if [[ -d "temp_dir" && ! -z "temp_dir" ]]; then
	directory="${start_interval}_$end_interal"
	mkdir -p "$2/$directory"
	mv temp_dir/* "$2/$directory/"
fi


