head -n 46 /etc/passwd | tail -n 18 | cut -d ":" -f3 |rev | cut -c1 | rev
