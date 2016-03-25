#!/bin/bash

# bash x.sh file.fasta 10

bioawk -c fastx '{ print $name, length($seq) }' < $1 | cut -f 2 | head -n $2 | awk '{s+=$1} END {print s}'
