#!/bin/bash
find ~ -type d | while read -r directory
do 
    chmod 755 "$directory"
done

#find ~ -type d -exec chmod 755 {} \;