#!/bin/bash

echo "Please, inpust string"
read -r string 

if [[ "$#" -ne 0 ]]; then
	for arg in "$@"
	do
		grep -o "$string" "$arg" | wc -l
	done
fi

