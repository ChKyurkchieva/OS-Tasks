ps -eo group,rss | grep "^root"| \
	awk '{sum+=$2} END {print sum/1024, "MB"}'


