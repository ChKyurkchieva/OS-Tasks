#!/bin/bash

if [[ "$#" -eq 0 ]]; then 
	echo "Something went wrong!"
	exit 1
fi

files=''
comSed1="sed "
comSed2="sed "
for parameter in "$@" 
do
	if [[ $parameter == -* ]]; then
		#not filename
		if [[ $parameter =~ ^-R[^=]+=.+$ ]]; then 
			#valid parameter
			first_word="${parameter%%=*}"
			second_word="${parameter#*=}"
			first_word="${first_word:2}"
			temp=$(pwgen 10 1)
			sed_param="-e 's/$first_word/$temp/g' "
			comSed1+="$sed_param"

			sed_param="-e 's/$temp/$second_word/g' "
			comSed2+="$sed_param"

		else
			echo "Invaid parameter"
			exit 1
		fi

	else
		#filename
		files+="$parameter "
	fi
done

for file in $files 
do
	temp=$(eval "$comSed1 $file | $comSed2")
	echo "$temp" > $file
done






