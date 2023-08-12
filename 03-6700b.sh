find /tmp/ -readable 2>/dev/null -exec ls -l {} \; | awk "{print $1, $9}"
