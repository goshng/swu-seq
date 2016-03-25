#!/bin/bash

# Run this script after a run of DOGMA annotation.
# bash src/sh/genomevx-draw.sh out/spades-bwa-jdj0/scaffolds.fasta 1000 out/spades-bwa-jdj0/scaffolds.fa.dogma.txt out/spades-bwa-jdj0/scaffolds.pdf

if [ $# -eq 0 ]; then
  echo "bash x.sh <fasta file> <contig limit> <dogma annotation> <pdf file>"
  exit
fi

FASTA=$1
CLIMIT=$2
DOGMA=$3
PDF=$4


#####
# Annotation:
# genes, start, end, strand, color
# Find the number of genes: 106
# Limit: 1000
#

bash src/sh/filter-fasta-by-length.sh $FASTA $CLIMIT > tmp/scaffolds.fasta.sub
bash src/sh/fa2single.sh tmp/scaffolds.fasta.sub chr1 > tmp/scaffolds.fa

# Download the annotation of the scaffolds.
bioawk -c fastx '{ print $name, length($seq) }' < tmp/scaffolds.fasta.sub > tmp/scaffolds.fa.len
perl src/pl/falen2bed.pl < tmp/scaffolds.fa.len > tmp/scaffolds.fa.len.bed
CLENGTH=$(bioawk -c fastx '{ print length($seq) }' < tmp/scaffolds.fa)

N=`cut -f 3 $DOGMA | wc -l | awk {'print $1'}`
NGENE=$N
cut -f 3 $DOGMA > tmp/dogma-c1.txt
cut -f 1 $DOGMA > tmp/dogma-c2.txt
cut -f 2 $DOGMA > tmp/dogma-c3.txt
cut -f 4 $DOGMA > tmp/dogma-c4.txt
for (( c=1; c<=N; c++ )); do echo $(( ( RANDOM % 31 )  + 1 )); done > tmp/dogma-c5.txt


# Find the number of contigs: 17
N=`wc -l tmp/scaffolds.fa.len.bed | awk {'print $1'}`
cut -f 4 tmp/scaffolds.fa.len.bed >> tmp/dogma-c1.txt
cut -f 2 tmp/scaffolds.fa.len.bed >> tmp/dogma-c2.txt
cut -f 3 tmp/scaffolds.fa.len.bed >> tmp/dogma-c3.txt
for (( c=1; c<=N; c++ )); do echo I; done >> tmp/dogma-c4.txt
for (( c=1; c<=N; c++ )); do echo $(( ( RANDOM % 31 )  + 1 )); done >> tmp/dogma-c5.txt

paste tmp/dogma-c?.txt > tmp/genomevx-input.txt

draw_genome tmp/genomevx-input.txt -stdout $CLENGTH -color Nancho -n:$NGENE Nancho | ps2pdf - > $PDF; open $PDF
echo See tmp/genomevx-input.txt

