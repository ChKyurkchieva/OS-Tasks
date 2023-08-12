cat ~/population.csv | tr "," " " | grep " 1969 " | rev | cut -d" " -f1,2,3|rev|sort -k3,3rn | head -n42 | tail -n1
grep "LKA" ~/population.csv | tail -n1 | cut -d, -f4
