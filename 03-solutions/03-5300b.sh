awk -F: "{print$5}" /etc/passwd | awk -F, "{print $1}" | grep -o .|sort|uniq -c| sort -n | grep -E " 1 [a-z, A-Z, а-я, А-Я]" | wc -l 
cut -d: -f1 /etc/passwd | grep -o | sort -u | wc -l
