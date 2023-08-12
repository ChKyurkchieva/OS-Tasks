find /usr/include -type f \( -name "*.c" -o -name "*.h" \) -exec wc -l {} + | awk "{sum += $1} END {print sum}"
