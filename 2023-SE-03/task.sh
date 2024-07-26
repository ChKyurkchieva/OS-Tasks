#!/bin/bash

function stopWord()
{
                allFiles=$(find $2 -type f | wc -l)
                ((allFiles/=2))
        filesCounter=0
        for file in $(find $2 -type f)
        do
                occurences=$(grep -o "$1" $file | wc -l)
                if [[ $occurences -ge 3 ]];then
                        ((filesCounter+=1))
                fi
        done

        if [[ $filesCounter -ge $allFiles ]]; then
                echo $1 >> $4
        fi
}

wordCandidates=$(mktemp)

cat $(find $1 -type f) | grep -Eoi '[a-z]+' | sort | uniq -c | sort -r -n | rev | cut -d' ' -f 1,2 | rev >> $wordCandidates

countFiles=$(find $1 -type f | wc -l )

minWordOccurences=$((countFiles*3/2))

stopWordCandidates=$(mktemp)

candidates=$(mktemp)

awk -v wordL="$minWordOccurences" '$1 >= wordL {print $0}' "$wordCandidates" > "$candidates"

cat $candidates | cut -d' ' -f 2 > $stopWordCandidates

wordLimit=$((countFiles*3/2))

stopWords=$(mktemp)
for word in $(cat $stopWordCandidates)
do
    stopWord $word $1 $minWordOccurences $stopWords
done

file=$(mktemp)
for word in $(cat $stopWords)
do
    grep $word $candidates >> $file
done

echo "stop words: "

cat $file | sort -nr | uniq | head | cut -d' ' -f2

echo "cleaning up"
rm $wordCandidates $stopWordCandidates $candidates $stopWords $file