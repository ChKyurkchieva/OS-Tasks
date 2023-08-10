sed "s/a//g ; s/\s//g" /etc/passwd | wc -m
grep -e "a" /etc/passwd | wc -m
