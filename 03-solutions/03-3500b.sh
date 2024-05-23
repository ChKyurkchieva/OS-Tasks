grep -lE "^#!.*(/bash|/sh)" /bin/* 2>/dev/null | wc -l
grep -E "ASCII text" /bin/* 2>/dev/null | wc -l
