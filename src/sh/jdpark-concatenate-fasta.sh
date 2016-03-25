#!/bin/bash

# bash <fasta file 1> <fasta file 2> <output fasta file>

if [ $# -eq 0 ]; then
  echo "bash <fasta file 1> <fasta file 2> <output fasta file>"
  exit
fi

FASTA1=$1
FASTA2=$2
OUT=$3

cat $FASTA1 $FASTA2 > $OUT

