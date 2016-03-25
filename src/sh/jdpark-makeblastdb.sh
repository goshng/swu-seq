#!/bin/bash

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <blastdb>"
  exit
fi

FASTA=$1
BLASTDB=$2

makeblastdb -dbtype nucl -in $FASTA -parse_seqids -out $BLASTDB


