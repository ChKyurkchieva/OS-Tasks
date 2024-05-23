find /tmp -type f -ls -group 'students' -perm -g=w || find /tmp -type f -ls -group 'students' -perm -o=w
