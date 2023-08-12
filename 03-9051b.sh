grep "2008" ~/population.csv | rev | awk -F, -v sum=$2 "{ sum += $2 }; END { print sum }"
grep "2016" ~/population.csv | rev | awk -F, -v sum=$2 "{ sum += $2 }; END { print sum }"
