#!/bin/bash

# bash x.sh 6

if [ $# -eq 0 ]; then
  echo "bash x.sh <END>"
  exit
fi

END=$1

echo 0 > out/spades-length0.txt
bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa/scaffolds.fasta | cut -f 2 >> out/spades-length0.txt

echo 1 > out/spades-length1.txt
bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj/scaffolds.fasta | cut -f 2 >> out/spades-length1.txt

for ((I=2;I<=END;I++)); do

echo $I > out/spades-length$I.txt
bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj$I/scaffolds.fasta | cut -f 2 >> out/spades-length$I.txt

done

paste out/spades-length?.txt > out/spades-length.txt
rm out/spades-length?.txt

echo See out/spades-length.txt