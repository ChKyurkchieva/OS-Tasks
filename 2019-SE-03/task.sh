#!/bin/bash
inode=$(find /home/velin -type f -printf "%T@ %i %p\n" 2>/dev/null | sort -rn -k1,1 | head -n 1 | cut -d' ' -f2)
$ find /home/velin -inum $inode 2> /dev/null -exec bash -c 'echo -n '{}' :; echo '{}' | grep -o / | wc -l' \; \ 
    | sed 's/://' | sort -n -k2,2 | cut -d' ' -f2

#not fully understand -exec part