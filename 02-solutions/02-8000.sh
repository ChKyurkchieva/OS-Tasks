cp -R $(stat --format=%A:%n /etc/* | grep -E a?r*r*r* | cut -d : -f2) ~/myetc
