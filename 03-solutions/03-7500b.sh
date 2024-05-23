cat /etc/services | tr -s "[:space:]" "\n" | tr "[:upper:]" "[:lower:]" | grep -o "[[:alpha:]]\+" | sort | uniq -c | sort -nr | head -n 10 | awk "{print $1, $2}"
