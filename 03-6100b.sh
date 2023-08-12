head -n 46 /etc/passwd | tail -n 18 | cut -d ":" -f3 |rev | cut -c1 | rev
sed -n "28,46p" /etc/passwd | cut -d: -f3 | awk "{print substr($0, length($0), 1)}"
