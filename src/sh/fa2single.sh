#!/bin/bash

# bash src/pl/fa2single.sh out/spades-bwa-jdj/scaffolds.fasta chr1

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <seq name>"
  exit
fi

FASTA=$1
SEQNAME=$2

cat $FASTA | grep -v '^>' | grep '^.' | tr -d '[:blank:]' | cat <( echo ">$SEQNAME") -
