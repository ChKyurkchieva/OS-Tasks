#!/bin/bash
cat /etc/passwd | grep 'SI' | cut -d':' -f5,6 | sed 's/,,,,SI//g' #delete with sed