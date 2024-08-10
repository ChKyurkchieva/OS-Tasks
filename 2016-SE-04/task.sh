#!/bin/bash
if [[ $# -ne 2 ]]; then 
    echo "Usage: $0 <integer> <integer>" 
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ && $2 =~ ^[0-9]+$ ]]; then
    echo "Expected two integers"
    exit 1
fi

if [[ $1 -gt $2 ]]; then 
    echo "Parameters are positional. Expecetd first parameter NOT be less than second one."
    exit 1
fi

directory=$(pwd)
mkdir -p "$directory/a" "$directory/b" "$directory/c"

for file in *;
do 
    if [[ -f "$file" ]]; then 
        fileLength=$(wc -l < "$file")

        case 1 in 
          $(( $fileLength < $1 )))
                mv $file $directory/"a"/$file
                ;;

          $(( $fileLength >= $1 && $fileLength <= $2 )))
                mv "$file" "$directory/b/$file"
                ;;
          $(( $fileLength > $2 )))
                mv "$file" "$directory/c/$file"
                ;;

        esac
    fi
done
