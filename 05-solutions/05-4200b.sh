#!/bin/bash

if [[ $# -ne 1 ]]; then 
	echo "Usage: $0 <c_source_fie>"
	exit 1
fi

file=$1

if [[ ! -f "$file" ]];then 
	echo "Error: File '$file' does NOT exist."
	exit 1
fi

depth=$(grep -o '[{}]' "$file" | awk 'BEGIN {max_depth = 0; current_depth = 0;}
{
	if ($1 == "{"){		
		current_depth++;
		if ( current_depth > max_depth){  
			max_depth = current_depth;
		}
	} else if ($1 == "}"){
		current_depth--;
	}
}END {print max_depth}')


echo "The deepest nesting is '$depth' levels."

