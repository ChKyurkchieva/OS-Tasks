cat ~/dir5/file1 ~/dir5/file2 ~/dir5/file3 | grep -o . |sort| uniq -c | sort -rn | head -n10
