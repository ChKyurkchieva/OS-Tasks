#!/bin/bash

pathFile=$(find . -type f -name "philip-j-fry.txt")
grep -E '[0,2,4,6,8]+' $pathFile | grep -Ev '[a-w]+' | wc -l