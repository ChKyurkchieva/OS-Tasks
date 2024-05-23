grep -E "/home/SI" ~/mypasswd.txt | awk -F: "{print $1}" |tr "s" " "| sort -n >> ~/si.txt
