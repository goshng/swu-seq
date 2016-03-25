#!/bin/bash

# bash grep-read-id.sh out/jdj-bwa out/jdj-bwa.txt

# Execute at a base directory of output directories of the ‘in vitro primer walking’ program by Dr. Jeong.
# You would have a file of read IDs.
# Each read ID should be prefixed numbers such as S88, S891, or S892.

if [ $# -eq 0 ]; then
  echo "bash x.sh <jdj dir> <id file>"
  exit
fi

JDJDIR=$1
IDFILE=$2

rm -f $IDFILE.unsorted

for i in $(find $JDJDIR -name \*forStr.fasta -print); do
  grep ">" $i | cut -c7- >> $IDFILE.unsorted
done

sort -n $IDFILE.unsorted | uniq > $IDFILE

