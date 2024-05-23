head -n12 /etc/passwd
head -c26 /etc/passwd
head -n $( expr $(wc -l /etc/passwd | cut -d  -f1) - 4) /etc/passwd
tail -n17 /etc/passwd
tail -n $(expr $(wc -l /etc/passwd | cut -d  -f1) - 150) /etc/passwd| head -n1
tail -n $(expr $(wc -l /etc/passwd | cut -d  -f1) - 12) /etc/passwd| head -n1| tail -c5
