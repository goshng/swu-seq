#!/bin/bash

# bash x.sh infile.fa 1000

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <length>"
  exit
fi

FASTA=$1
TOTALLENGTH=$2

bioawk -c fastx -v TOTALLENGTH="$TOTALLENGTH" '{L+=length($seq); if(L < TOTALLENGTH) { print ">"$name; print $seq }}' $FASTA
