#!/bin/bash

sed 's/ \+/ /g' ~/ssa-input.txt | awk 'NR>2' | awk '/^ Array/{array=$2} /^ physicaldrive/{drive=$2} /^ Current Temperature \(C\):/{current=$4} /^ Maximum Temperature \(C\):/{max=$4; print array"-"drive, current, max}'

