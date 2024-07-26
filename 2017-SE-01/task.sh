#!/bin/bash
find . -type f -links +1 -printf '%n %p\n' | sort -rn | hea
d -n5