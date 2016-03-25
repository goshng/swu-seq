bioawk -c fastx '{ print $name, length($seq) }' < $1 | less
