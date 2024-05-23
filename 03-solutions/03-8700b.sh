awk -F: "{print $4}" /etc/passwd | sort -n| uniq -c | sort -rn| head -n5 | awk "{print $2}"
awk -F: "{print $4}" /etc/passwd | sort -n| uniq -c | sort -rn| head -n5 | awk "{print $2}" | for gid in 512 256 65534 999 9; do awk -F: -v gid="$gid" "$3==gid {print $3, $1}" /etc/group; done
