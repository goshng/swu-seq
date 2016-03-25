#!/bin/bash

# bash x.sh NC_027250.1.fa 1.fq 2.fq

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <1.fq> <2.fq>"
  exit
fi

FASTA=$1
FASTQ1=$2
FASTQ2=$3

bwa index $FASTA

bwa mem -t 8 -k 19 -w 100 -d 100 -r 1.5 -c 10000 -A 1 -B 4 -O 6 -E 1 -L 5 -U 17 -T 30 $FASTA $FASTQ1 $FASTQ2 | samtools view -b -f 0x02 -F 4 - > $FASTA.bam

# -f 0x02: include paired reads

# samtools view -b -f 0x02

samtools sort -n $FASTA.bam -o $FASTA.sorted.bam

# samtools fastq $FASTA.bam -1 $FASTQ1-bwa_1.fq -2 $FASTQ2-bwa_2.fq

