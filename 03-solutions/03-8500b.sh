awk -F: -v group=students {print "Hello," group (group == $1 ? "-I`m here!" : "")} /etc/group
strudents is my GID
