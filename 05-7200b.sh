#!/bin/bash

for arg in "$@"; do
    # Проверка дали аргументът е файл
    if [ -f "$arg" ]; then
        if [ -r "$arg" ]; then
            echo "$arg е четим файл."
        else
            echo "$arg е файл, но не е четим."
        fi
    # Проверка дали аргументът е директория
    elif [ -d "$arg" ]; then
        echo "$arg е директория."
        
        # Намиране на броя на файловете в директорията
        total_files=$(find "$arg" -maxdepth 1 -type f | wc -l)

        # Извеждане на имената на файловете с размер по-малък от общия брой файлове в директорията
        echo "Файлове в $arg с размер по-малък от $total_files:"
        find "$arg" -maxdepth 1 -type f -size -"${total_files}c" -print
    else
        echo "$arg не е нито файл, нито директория."
    fi
done



