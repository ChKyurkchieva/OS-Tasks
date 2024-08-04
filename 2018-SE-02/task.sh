#!/bin/bash
#homeDirectory=$(eval echo ~$USER)
homeDirectory=$HOME
find $homeDirectory -type f -links +1 -printf "%T+ %i\n" | sort -r | head -n 1 | awk '{print $2}'
