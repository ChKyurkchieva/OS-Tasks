#!/bin/bash
if [[ ! $# -eq 1 ]]; then
echo "Usage: <command> <directory>"
exit 1
fi

if [[ ! -d $1 ]]; then
echo "Expectd directory!"
exit 1
fi

find $1 -type l -exec test ! -e {} \; -print 2>/dev/null