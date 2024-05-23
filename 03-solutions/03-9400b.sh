awk "{field=NF; for(i= field; i>=1; i--) printf "%s", $i (i==1 ? RS : OFS)}" ~/emp.data
