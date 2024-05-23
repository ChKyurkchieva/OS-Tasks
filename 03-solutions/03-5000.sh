grep -F s45523 /etc/passwd
head -n "$(awk {print NR,-bash} /etc/passwd | grep -E s45523* |cut -d   -f1)"/etc/passwd | tail -n 3
head -n "$(expr $(awk {print NR,-bash} /etc/passwd | grep -E s45523* |cut -d   -f1) + 3)" /etc/passwd | tail -n 6
head -n "$(awk {print NR,-bash} /etc/passwd | grep -E s45523* |cut -d   -f1)" /etc/passwd | tail -n 3 | head -n1
grep  -B2 Кюркчиева /etc/passwd
grep  -B2 -C3 Кюркчиева /etc/passwd
