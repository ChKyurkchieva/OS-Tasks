#!/bin/bash
files=$(find ~ -type f -perm 0644)
gOwner=$(find ~ -type f -perm 0644 -printf "%g\n" | sort | uniq)
for file in $files; do
    setfacl -m u:$gOwner:rw "$file"
done

