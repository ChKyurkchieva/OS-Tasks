#!/bin/bash

replace ()
{
        # $1: word to replace
        # $2: file where the replacement is to be done
        local word="$1"
        local file="$2"
        local lengthWord=${#word}
        local replacement=$(printf '%*s' "$lengthWord" | tr ' ' '*')
        sed -i -E "s/(^|\b|\s|[\.\!\?\,]\s+)$word(\b|[\.\!\?\,]|[ \t]*$)/\1$replacement\2/gI" "$file"
}

if [[ $# -ne 2 ]]; then
        echo "Usage: <command> <bad_words_file> <directory>"
        exit 1
fi

if [[ ! -f $1 ]]; then
        echo "Expected first parameter to be regular file"
        exit 1
fi

if [[ ! -d $2 ]]; then
        echo "Expected second parameter to be directory"
        exit 1
fi

for file in $(find $2 -type f -name '*.txt')
do
        for word in $(cat $1)
        do
                replace $word $file
        done
done