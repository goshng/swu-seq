#!/bin/bash

# bash x.sh NC_027250.1

if [ $# -eq 0 ]; then
  echo "bash x.sh <ncbi id>"
  exit
fi

NCBIID=$1

esearch -db nucleotide -query $NCBIID | efetch -format fasta > $NCBIID.fa

