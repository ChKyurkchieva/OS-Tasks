#!/bin/bash

#num_proc=$(ps -G root | wc -l)
#if [ $num_proc -lt 2 ]; then
#	echo "Group root has not processes!  "
#	exit 1
#fi

#sum_size=$(ps -G root -eo rss= | awk '{sum += $1}END{print sum}')
#average_proc_size=$(echo "scale=2; $sum_size/$num_proc"| bci)
#echo "Average size of each process of group root is: $average_proc_size"
ps -G root -eo rss= | awk \
	'{
	sum_size+=$1;
	num_process+=1;
	}; 
	END {
		if(num_process < 2)
			print "Group of root has not processes!" 
		else
			print "Average size of each process of roots group is: " sum_size/num_process 
	}'

