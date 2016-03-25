#!/bin/bash

# bash x.sh infile.fa 1000

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <length>"
  exit
fi

FASTA=$1
LENGTH=$2

bioawk -c fastx -v LENGTH="$LENGTH" '{ if(length($seq) > LENGTH) { print ">"$name; print $seq }}' $FASTA

