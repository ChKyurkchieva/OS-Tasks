#!/bin/bash

if [[ ! $# -eq 2 ]]; then 
	echo "Invalid number of parameters"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "Invalid first parameter! Expected valid non-empty directory_path"
	exit 1
fi

if [[  ${2: -4} != ".svg" ]]; then 
	echo "Invalid second parameter! Expected SVG file"
	exit 1
fi

header_files=$(find $1 -type f -name "*.h")
							  #| grep "*.h$")
temp_file=$(mktemp)

for file in $header_files 
do
	declarations=$(grep "^class [[a-zA-Z_]+[0-9]*]+ ")
	for line in $declarations
	do
		cName=$(cut -d' ' -f2 $line)
		echo "$cName" >> "$temp_file"
		parents=$(cut -d':' -f2 | sed 's/public//g; s/private//g; s/protected//g' | tr ',' '\n')
		for parent in $parents
		do
			parent=$(echo "$parent" | awk '{$1=$1};1')  # Trim whitespace
			if [[ -n $parent ]]; then
				echo "$parent -> $cname" >> "$temp_file"  # Write the inheritance as an edge to temp file
			fi
		done
	done
done

dag-ger < $temp_file > $2

rm "$temp_file"
