#!/bin/bash

cat /etc/passwd | cut -d':' -f1,5 | grep '^s' | grep 'Inf'| cut -d',' -f1| grep -E '[a, а]+$' | cut -c2,3 | sort -n | uniq -c | head -n1