ps -eo tty,pid,comm --sort=-comm| grep "^?" | awk "{print $3}" |sort|uniq -c|rev|cut -d" " -f1|rev
