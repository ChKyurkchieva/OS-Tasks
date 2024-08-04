#!/bin/bash
user=$(whoami)
find / -type f -user "$user" | grep -E '\.blend[0-9]+$' #\. escape the dot
#find / -type f -user "$user" -name '*.blend[0-9]' -print'