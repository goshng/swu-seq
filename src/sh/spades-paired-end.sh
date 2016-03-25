#!/bin/bash

# bash x.sh 1.fq 2.fq out/spades-bwa

if [ $# -eq 0 ]; then
  echo "bash x.sh <1.fq> <2.fq> <out dir>"
  exit
fi

FASTQ1=$1
FASTQ2=$2
OUTDIR=$3
mkdir $OUTDIR

src/SPAdes-3.6.2-Darwin/bin/spades.py --pe1-1 $FASTQ1 --pe1-2 $FASTQ2 --careful -o $OUTDIR

