grep "Bulgaria" ~/population.csv | cut -d, -f3,4 | tr "," " " |sort -k2,2rn |head -n1
