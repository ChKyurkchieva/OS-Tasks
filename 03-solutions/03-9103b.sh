find ~/songs | cut -d"-" -f2| rev | cut -d. -f2 | cut -d"(" -f2 |rev|tr [:upper:] [:lower:]| tr " " "-" | grep "-"|sort|cut -c 2-
