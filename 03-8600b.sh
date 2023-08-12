find /usr -type f -name "*.sh" -exec head -n 1 {} \; | grep "#!" | tr -t "#" " " | tr -t "!" " " | sort | uniq -c | sort -rn
