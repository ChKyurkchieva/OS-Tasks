#!/bin/bash

num_proc=$(ps -G root | wc -l)
if [ $num_proc -lt 2 ]; then
	echo "Group root has not processes!  ">&2; exit 1;
fi

sum_size=$(ps -G root -eo rss | awk '{sum += $1}END{print sum}')
average_proc_size=$(echo "scale=2; $sum_size / $num_proc" | bc)
echo "Average size of each process of group root is: $average_proc_size"


