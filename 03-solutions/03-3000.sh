df -P >> ~/resultFile
tail -n $(expr $(wc -l ~/resultFile | cut -d  -f1) - 1) ~/resultFile | sort -n -k2,2
