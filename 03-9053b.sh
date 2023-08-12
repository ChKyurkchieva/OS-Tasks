grep "2016" ~/population.csv | rev| cut -d"," -f1,2,3|rev | tr "," " " |sort -k3,3rn|head -n1
grep "2016" ~/population.csv | rev| cut -d"," -f1,2,3|rev | tr "," " " |sort -k3,3rn|tail -n1
