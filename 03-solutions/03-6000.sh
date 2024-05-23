awk "{sum++} END {print sum}" ~/emp.data
awk "sum++ {if(sum == 3){print $0}}" ~/emp.data
awk "{if(NR == 6) print $3}" ~/emp.data
awk "{print $3}" ~/emp.data
awk "{if (NF>4) {print $0}}" ~/emp.data
awk "{if ($3>4) {print $0}}" ~/emp.data
awk "{if ($NF>4) {print $0}}" ~/emp.data
awk "{sum+=NF} END {print sum}" ~/emp.data
awk "{if ("/Beth/") {sum++}} END {print sum}" ~/emp.data
awk "BEGIN {max_value=-INF} $3 > max_value{max_value=$3; max_line=$0} END {print "Max_Value: ", max_value, " max line: ", max_line}" ~/emp.data
awk "length($0) > 17" ~/emp.data
awk "if(NF) {print $0}" ~/emp.data
awk "{print NF, " " $0}" ~/emp.data
awk "{print $2, " " $1}" ~/emp.data
awk "{ temp = $1; $1 = $2; $2 = temp; print $0 }" ~/emp.data
awk "{$1=NR; print $0}" ~/emp.data
awk "{$2=""; print $0}" ~/emp.data
awk "{for (i=1; i<=NF; i++) {if (i!=2) printf "%s", $i (i==NF ? RS : OFS)}}" ~/emp.data
awk "{sum = $2+$3; print sum}" ~/emp.data
awk "{sum += $2+$3} END {print sum}" ~/emp.data
