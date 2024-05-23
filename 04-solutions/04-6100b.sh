ps -eo user,cmd | grep vim | sort | uniq -c | \
	awk '{if ($1 >= 2) print $2}'
