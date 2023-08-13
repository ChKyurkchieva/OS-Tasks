ps -eo user,rss | grep "^root"| awk "{sum+=$2} END {print sum/1024, "MB"}"
ps -G $(cat /etc/group | grep root | cut -d: -f3) -eo cmd,size | awk "{size+=$2} END {print size/1024 " MB"}"
