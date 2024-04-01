ps -eo tty=,pid=,comm= --sort=-comm | grep '^?' | \
	awk '{print $2 " "$3}' | sort -k 2,2 | uniq -c| \
	rev | cut -d" " -f 1 | rev
