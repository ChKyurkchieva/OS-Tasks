ps -eo user,cmd | grep vim | sort| uniq -c | awk "{print ($1 >=2) ? $2 : " "}"
